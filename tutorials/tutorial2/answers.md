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

I was correct. I learned that I was correct.

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

## Answers to questions in section 6

```
Q: Is the assembly you generated efficient?  Give an example of your output to make your case. How do you think this relates more broadly to code generation and optimization techniques?
A: By no means is it efficient. For example, R1 = 1 + 3; could be optimized to R1 = 4; Initially, it's important to generate correct assembly code, only then should we start worrying about efficiency.

Q: Instead of printing the assembly while parsing, what advantages could be had by building a data structure to represent the instructions?
A: We could optimize the assembly code by reusing registers, for example, if we have the expression R1 = R2 + R3, we could reuse R2 and R3 in the next expression, if they are not used in the next expression (unless they are used in a different part of the program).

Q:  [ECE566] Describe at least one thing that would have to change in your code to make this possible.
A: We would have to build a data structure to represent the instructions, and then we would have to optimize the assembly code by reusing registers.

```