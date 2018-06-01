## Useful commands

Reformat PHP code :

    php-cs-fixer fix <source-dir> --rules='{"@Symfony": true, "method_chaining_indentation": true, "array_indentation": true, "binary_operator_spaces": {"align_double_arrow": true}}'

Reformat C code :

    clang-tidy <source-files> -fix -checks="*" -- <compiler-args>
    clang-format -i -style=file <source-files>

>The `.clang-format` file must be present in the current working directory.
