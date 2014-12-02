module freecellPlayer(clock, source, dest, win);

input [3:0] source, dest;
input clock;

output reg win;

reg [5:0] tableau[7:0][51:0];
reg [5:0] freecell[3:0];
reg [5:0] homecell[3:0][12:0];
reg [5:0] sourceCard, destCard;
reg validDestination, validSource, validSuits, validValues, possibleWin;

integer i, j;

/*  Each card has 6-bits, first 2 bits are suit, next 4 are value
    Club = 00, Diamond = 01, Spade = 10, Heart = 11
    In the tableau and homecells, the highest index entries are the "deepest" (e.g. if there is a card in index 0 of the tableau that means every card in the deck is in that column
*/

initial begin
  //Column 0
  tableau[0][51] = 6'b100100;
  tableau[0][50] = 6'b011011;
  tableau[0][49] = 6'b011010;
  tableau[0][48] = 6'b010110;
  tableau[0][47] = 6'b100011;
  tableau[0][46] = 6'b010001;
  tableau[0][45] = 6'b110001;
  for (i = 0; i < 45; i = i + 1)
    tableau[0][i] = 6'b000000;
    
  //Column 1
  tableau[1][51] = 6'b100101;
  tableau[1][50] = 6'b101010;
  tableau[1][49] = 6'b111000;
  tableau[1][48] = 6'b000100;
  tableau[1][47] = 6'b110110;
  tableau[1][46] = 6'b111101;
  tableau[1][45] = 6'b110010;
  for (i = 0; i < 45; i = i + 1)
    tableau[1][i] = 6'b000000;
  
  //Column 2
  tableau[2][51] = 6'b101011;
  tableau[2][50] = 6'b000111;
  tableau[2][49] = 6'b001001;
  tableau[2][48] = 6'b000110;
  tableau[2][47] = 6'b000010;
  tableau[2][46] = 6'b101101;
  tableau[2][45] = 6'b000001;
  for (i = 0; i < 45; i = i + 1)
    tableau[2][i] = 6'b000000;
    
  //Column 3
  tableau[3][51] = 6'b110100;
  tableau[3][50] = 6'b100001;
  tableau[3][49] = 6'b001100;
  tableau[3][48] = 6'b000101;
  tableau[3][47] = 6'b100111;
  tableau[3][46] = 6'b111001;
  tableau[3][45] = 6'b101000;
  for (i = 0; i < 45; i = i + 1)
    tableau[3][i] = 6'b000000;
  
  //Column 4
  tableau[4][51] = 6'b011100;
  tableau[4][50] = 6'b111011;
  tableau[4][49] = 6'b101100;
  tableau[4][48] = 6'b100110;
  tableau[4][47] = 6'b010010;
  tableau[4][46] = 6'b101001;
  for (i = 0; i < 46; i = i + 1)
    tableau[4][i] = 6'b000000;
  
  //Column 5
  tableau[5][51] = 6'b010101;
  tableau[5][50] = 6'b011101;
  tableau[5][49] = 6'b000011;
  tableau[5][48] = 6'b011001;
  tableau[5][47] = 6'b110011;
  tableau[5][46] = 6'b100010;
  for (i = 0; i < 46; i = i + 1)
    tableau[5][i] = 6'b000000;
  
  //Column 6
  tableau[6][51] = 6'b110101;
  tableau[6][50] = 6'b010011;
  tableau[6][49] = 6'b111100;
  tableau[6][48] = 6'b010111;
  tableau[6][47] = 6'b001101;
  tableau[6][46] = 6'b001010;
  for (i = 0; i < 46; i = i + 1)
    tableau[6][i] = 6'b000000;
  
  //Column 7
  tableau[7][51] = 6'b001011;
  tableau[7][50] = 6'b010100;
  tableau[7][49] = 6'b111010;
  tableau[7][48] = 6'b001000;
  tableau[7][47] = 6'b110111;
  tableau[7][46] = 6'b011000;
  for (i = 0; i < 46; i = i + 1)
    tableau[7][i] = 6'b000000;
    
  //Freecells
  for (i = 0; i < 4; i = i + 1)
    freecell[i] = 6'b000000;
  
  //Homecellls
  for (i = 0; i < 4; i = i + 1) begin
    for (j = 0; j < 13; j = j + 1) begin
      homecell[i][j] = 6'b000000;
    end
  end
  
  //Validity values to FALSE
  validDestination = 1'b0;
  validSource = 1'b0;
  validSuits = 1'b0;
  validValues = 1'b0;
  
end

always @(posedge clock) begin

  sourceValid;
  destValid;

  if (validSource && validDestination) begin
    if (dest[3:2] == 2'b10) //Don't need to check suit + value if moving to a freecell
      doMove;
    else begin
      suitsValid;
      valuesValid;
    
      if (validSuits && validValues)
        doMove;
    end
  end

  checkWin;   
end 

//Task to get available card value from source
task getSourceCardValue;
  begin
    sourceCard = 6'd0;
    
    case(source[3:2])
      //Tableau
      2'b00,
      2'b01: begin
        i = 0;
        while (tableau[source[2:0]][i] == 6'd0 && i < 52) begin
          i = i + 1;
        end
        sourceCard = tableau[source[2:0]][i];
      end
      //Freecell
      2'b10: begin
        sourceCard = freecell[source[1:0]];
      end
    endcase
  end
endtask

//Task to get card value from destination
task getDestCardValue;
  begin
    destCard = 6'd0;
    
    case (dest[3:2])
      //Tableau
      2'b00,
      2'b01: begin
        i = 0;
        while (tableau[source[2:0]][i] == 6'd0 && i < 52) begin
          i = i + 1;
        end
        destCard = tableau[source[2:0]][i];
      end
      
      //Homecell
      2'b11: begin
        i = 0;
        while (homecell[sourceCard[5:4]][i] == 6'd0 && i < 13) begin
          i = i + 1;
        end
        destCard = homecell[sourceCard[5:4]][i];
      end
    endcase
  end
endtask

//Task to determine validity of the source value
task sourceValid;
  begin
    validSource = 1'b0;
    
    case (source[3:2])
      //Tableau column are valid if there is at least card in the column
      2'b00,
      2'b01: begin
        for (i = 0; i < 52; i = i + 1) begin
          if (tableau[source[2:0]][i] != 6'd0)
            validSource = 1'b1;
        end
      end
      //Freecell only valid if not empty
      2'b10: begin
        if (freecell[source[1:0]] != 6'd0)
          validSource = 1'b1;
      end
    endcase
  end
endtask

//Task to determine validity of the destination value
task destinationValid;
  begin
    validDestination = 1'b0;
    
    case (dest[3:2])
      //Tableau column is valid if there is at least one available space in the column
      2'b00,
      2'b01: begin
        if (tableau[dest[2:0]][51] == 6'd0)
          validDestination = 1'b1;
      end
      //Free cell only valid if empty
      2'b10: begin
        if (freecell[dest[1:0]] == 6'd0)
          validDestination = 1'b1;
      end
      //Homecell are always valid
      2'b11:
        validDestination = 1'b1;
    endcase
  end
endtask

task suitsValid;
  begin
    validSuits = 1'b0;
    
    case (sourceCard[5:4])
      //If source is black, only valid if dest is red
      2'b00,
      2'b10: begin
        if (destCard[5:4] == 2'b01 || destCard[5:4] == 2'b11)
          validSuits = 1'b1;
      end
      2'b01,
      2'b11: begin
        if (destCard[5:4] == 2'b00 || destCard[5:4] == 2'b10)
          validSuits = 1'b1;
      end
    endcase
  end
endtask

task valuesValid;
  begin
    validValues = 1'b0;
    
    //If moving to tableau, destination card's value needs to be source's value + 1
    if (dest[3] == 1'b0) begin
      if (destCard[3:0] - 4'd1 == sourceCard[3:0])
        validValues = 1'b1;
    end
    
    //If moving to a homecell, destination card's value needs to be source's value - 1
    if (dest[3:2] == 2'b11) begin
      if (destCard[3:0] + 4'd1 == sourceCard[3:0])
        validValues = 1'b1;
    end
  end
endtask

task doMove;
  begin
    case (source[3:2])
      //From tableau
      2'b00,
      2'b01: begin
        case (dest[3:2])
          //To tableau
          2'b00,
          2'b01: begin
            i = 0;
            //Find first card in dest column
            while (tableau[dest[2:0]][i] == 6'd0 && i < 52)
              i = i + 1;
            i = i - 1; //Get location of space in dest column
            tableau[dest[2:0]][i] = sourceCard; //Add card to column
        
            i = 0;
            //Find first card in source column
            while (tableau[source[2:0]][i] == 6'd0 && i < 52)
              i = i + 1;
            i = i - 1;
            tableau[source[2:0]][i] = 6'd0; //Remove card from column
          end
      
          //To free cell
          2'b10: begin
            freecell[dest[1:0]] = sourceCard;
        
            i = 0;
            //Find first card in source column
            while (tableau[source[2:0]][i] == 6'd0 && i < 52)
              i = i + 1;
            i = i - 1;
            tableau[source[2:0]][i] = 6'd0; //Remove card from column
          end
      
          //To homecell
          2'b11: begin
            i = 0;
            //Find first card in homecell
            while (homecell[sourceCard[5:4]][i] == 6'd0 && i < 13)
              i = i + 1;
            i = i - 1; //Get location of open space in homecell
            homecell[sourceCard[5:4]][i] = sourceCard;
        
            i = 0;
            //Find first card in source column
            while (tableau[source[2:0]][i] == 6'd0 && i < 52)
              i = i + 1;
            i = i - 1;
            tableau[source[2:0]][i] = 6'd0; //Remove card from column
          end
        endcase
      end 
    
      //From freecell
      2'b10: begin
        case (dest[3:2])
          //To tableau
          2'b00,
          2'b01: begin
            i = 0;
            //Find first card in dest column
            while (tableau[dest[2:0]][i] == 6'd0 && i < 52)
              i = i + 1;
            i = i - 1; //Find first space in dest column
            tableau[dest[2:0]][i] = sourceCard; //Add card from column
            
            //Clear freecell
            freecell[source[1:0]] = 6'd0;
          end
        
          //To freecell
          2'b10: begin
            freecell[dest[1:0]] = sourceCard; //Add card to dest freecell
            freecell[source[1:0]] = 6'd0; //Clear source freecell
          end
        
          //To homecell
          2'b11: begin
            i = 0;
            //Find first card in homecell
            while (homecell[sourceCard[5:4]][i] == 6'd0 && i < 13)
              i = i + 1;
            i = i - 1; //Get location of open space in homecell
            homecell[sourceCard[5:4]][i] = sourceCard;
          
            freecell[source[1:0]] = 6'd0; //Clear source freecell
          end
        endcase
      end
    endcase
  end
endtask

task checkWin;
  begin
    possibleWin = 1'b1;
    
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 13; j = j + 1) begin
        if (homecell[i][j] == 6'd0)
          possibleWin = 1'b0;
      end
    end
    
    if (possibleWin)
      win = 1'b1;
  end
endtask

endmodule