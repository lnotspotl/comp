## Answers to questions in section 3

```
Q: What happens if you input something like this:?  R0 R23 453 -16 -17   What tokens do you get? 
A: REG: 0 REG: 2 IMM: 3 IMM: 453 MINUS IMM: 16 MINUS IMM: 17

Q: What happens if you don’t explicitly detect errors on other unexpected characters (like $ or *)?
A: No syntax error is detected (assuming $ is an illegal character), the lexer falls back to a default action.

Q: Does this scanner guarantee that immediates are within a particular range? 
A: No, intermediate values (when converted to an integer) are not checked for range, this potentially leads to overflows and unexpected program behavior.

Q: Could you modify the scanner with additional functionality, like support for scanning other arithmetic operators? 
A: Yes, I could:
    "*"        { printf("MULTIPLY "); }
    "%"        { printf("MOD "); }
    "/"        { printf("DIVIDE "); }

```

## Answers to questions in section 4

```
Q: Create your own input expression different from the ones above and write down what you think the output will be. Then compare to the actual output. Were you right or wrong? Describe what you observed or learned from this.
A:
    R1 = -1;

Expected output:
    IMMEDIATE
    MINUS expr
    REG ASSIGN expr SEMI

Actual output:
    IMMEDIATE
    MINUS expr
    REG ASSIGN expr SEMI

I was correct.

Q: Do you see a pattern in the order of the printfs shown above? What is it?
A: Yes, we are parsing the input from individual tokens to the whole program, i.e. atomic pieces are combined to form the whole program.

Q: [ECE566] Show how you would extend the grammar to support a store instruction. 
A:
    %token STORE // has to be identified as a token first

    %%
    program:
        REG ASSIGN expr SEMI // original
        | STORE REG SEMI // new store instruction
```