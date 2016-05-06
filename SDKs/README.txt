5/5/16

Internal note for code on CGP's development computer: The "SMCoreLib Framework" directory is a hard link to the same framework in a different location (hln; See http://stackoverflow.com/questions/1432540/creating-directory-hard-links-in-macos-x). I did this to enable Git to upload this framework, and yet still be able to keep the primary files in a different location (the directory "Common" on my system).
