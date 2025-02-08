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