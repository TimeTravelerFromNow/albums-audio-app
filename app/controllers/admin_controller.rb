class AdminController < ApplicationController
  http_basic_authenticate_with name: "rails-app-enjoyer", password: "supersecret"

  #layout 'authors'
end
