# Simple sending script example

I use it for acceptance testing of this gem. This code should be always working, if not, please open an issue.

# Setup
You need to set these enviroment variables before using it:
```sh
export AWS_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export AWS_REGION=us-east-1
export MY_PHONE_NUMBER=+10000000000 # Set your phone number
```

Check gem readme on how to get `AWS_ACCESS_KEY` and `AWS_SECRET_ACCESS_KEY`.

# Running
Install gem deps,
then just add execution permission to the script and run it:

```sh
$ bundle install
$ chmod +x send.rb
$ ./send.rb
```
