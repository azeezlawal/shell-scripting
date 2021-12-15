In Shell, We have multiple shells , Out of that we are going with BASH.

BASH = SH + KSH + CSH (On server side BASH is default)
ZSH (Too much modern, But most on Desktop env, Not on server)

Topics we are going to discuss in shell 

1. She-Bang & Comments
2. Print Messages on Screen 
3. Variables 
4. Take Inputs 
5. Functions
6. Redirectors, Quotes, Exit States
7. Conditions
8. Loops
9. testing
10. testing

```
#! is called as She-bang , It denotes path of interpreter. Also ensures the code that is present in the file executes with that interpreter. It has to be in the very first line

```

## RoboShop Project

1. Keep all components in one script 
        Problem: We need to run only one component in one server
2. Make Individual scripts for each component 
        Problem: Making inividual may not make the code DRY(Dont repeat Yourself)

Solution: Use single script, But call individual script on provided input