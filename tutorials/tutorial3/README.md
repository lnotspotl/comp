```
Q: What changes to the grammar allow it to support multi-statement programs?
A: The grammar allows for multiple statements to be executed by adding a `;` between each statement. This was grammar rule was introduced in the first half of the tutorial.

Q: Why do we use LLVMValueRef/Value* as the type for the expr?
A: It's because Value is an abstract class representing any possible expression.

Q: What is constant folding, and how does it help in this program?
A: Constant folding performs simple arithmetic calculation at compile time, thereby reducing the number of static instructions and also the number of dynamic instructions, resulting in faster execution.

Q: What is constant folding, and how does it help in this program?
A: Everything else is optimized out using the constant folding technique.
```