# slugify - Converts a string into a URL-friendly slug.
#
# This function takes a string as an argument and performs the following transformations:
# 1. Converts the entire string to lowercase.
# 2. Replaces one or more whitespace characters with a single hyphen.
# 3. Removes any characters that are not lowercase letters, numbers, or hyphens.
# 4. Collapses any sequences of multiple hyphens into a single hyphen.
#
# Usage:
#   slugify "Your String With Spaces & Special Chars!"
#   => your-string-with-spaces-special-chars
#
function slugify
    # Check if an argument was provided.
    if test -z "$argv[1]"
        echo "Usage: slugify \"<string>\""
        return 1
    end

    # Process the first argument through a pipeline of string manipulations.
    # The final step uses `sed` to reliably collapse multiple hyphens,
    # avoiding issues with some `string replace` versions.
    echo "$argv[1]" | \
        string lower | \
        string replace --all --regex '\s+' '-' | \
        string replace --all --regex '[^a-z0-9-]' '' | \
        sed 's/--\+/-/g' | \
        string trim --chars='-'
end

# To make this function available in all your fish sessions,
# you can save it to a file in your fish configuration directory.
#
# 1. Create the file:
#    touch ~/.config/fish/functions/slugify.fish
#
# 2. Add the function code above to this new file.
#
# After saving, the `slugify` command will be immediately available
# in your terminal.

