### Run app

## Create project folder
  $ mkdir your_folder_name

## Go to your project folder
  $ cd your_folder_name

## Clone project

## Build docker
  $ MSYS_NO_PATHCONV=1 docker run -v "${PWD}/app:/app" -it -w /app ruby:3.0 bash
  
## Install dependencies
  $ bundle install
  
## Run
  $ ruby app.rb