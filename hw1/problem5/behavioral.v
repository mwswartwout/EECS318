module behavioral(out, a, b, e, w);

output out;

reg a, b, e, w;

if (~a && ~b && ~e && ~w)
begin
	a = 1'b0;
	b = 1'b0;
	out = 1'b1;
end 

if (~a && ~b && ~e && w)
begin
	a = 1'b0;
	b = 1'b1;
	out = 1'b1;
end

if (~a && ~b && e && ~w)
begin
	a = 1'b1;
	b = 1'b0;
	out = 1'b1;
end

if (~a && ~b && e && w)
begin
	a = 1'b1;
	b = 1'b1;
	out = 1'b1;
end

if (~a && b && ~e && ~w)
begin
	a = 1'b0;
	b = 1'b1;
	out = 1'b0;
end

if (~a && b && ~e && w)
begin
	a = 1'b0;
	b = 1'b1;
	out = 1'b0;
end

if (~a && b && e && ~w)
begin
	a = 1'b1;
	b = 1'b1;
	out = 1'b0;
end

if (~a && b && e && w)
begin
	a = 1'b1;
	b = 1'b1;
	out = 1'b0;
end

if (a && ~b && ~e && ~w)
begin
	a = 1'b1;
	b = 1'b0;
	out = 1'b0;
end

if (a && ~b && ~e && w)
begin
	a = 1'b1;
	b = 1'b1;
	out = 1'b0;
end

if (a && ~b && e && ~w)
begin
	a = 1'b1;
	b = 1'b0;
	out = 1'b0;
end

if (a && ~b && e && w)
begin
	a = 1'b1;
	b = 1'b1;
	out = 1'b0;
end

if (a && b && ~e && ~w)
begin
	a = 1'b0;
	b = 1'b0;
	out = 1'b0;
end

if (a && b && ~e && w)
begin
	a = 1'b1;
	b = 1'b1;
	out = 1'b0;
end

if (a && b && e && ~w)
begin
	a = 1'b1;
	b = 1'b1;
	out = 1'b0;
end

if (a && b && e && w)
begin
	a = 1'b1;
	b = 1'b1;
	out = 1'b0;
end

endmodule
