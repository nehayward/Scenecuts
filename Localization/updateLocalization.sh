find ./ -name "*.swift" -print0 | xargs -0 genstrings -o en.lproj

# Resource - https://stackoverflow.com/questions/2744401/how-to-use-genstrings-across-multiple-directories