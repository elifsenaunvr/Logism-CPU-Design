module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    wire axb;        // a XOR b
    wire ab;         // a AND b
    wire cin_axb;    // cin AND (a XOR b)

    assign axb     = a ^ b;
    assign sum     = axb ^ cin;

    assign ab      = a & b;
    assign cin_axb = cin & axb;

    assign cout    = ab | cin_axb;

endmodule
