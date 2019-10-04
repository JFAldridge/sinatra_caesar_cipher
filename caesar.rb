require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'




get '/' do
  erb :intro
end

get '/caesar' do
  @encoded = session[:encoded]
  erb :caesar
end

def caesar_cipher(str, shft)
  lower_alphabet = ("a".."z").to_a
  upper_alphabet = ("A".."Z").to_a
  punctuation = [".", "'", "!", "?", '"']
  shft_int = shft.to_i

  shfted_str_arr = str.split('').map{ |char|
  if lower_alphabet.include?(char)
    shfted_index = lower_alphabet.index(char) + shft_int
    if shfted_index < 0
      shfted_index += 26
    elsif shfted_index > 26
      shfted_index -= 26
    end
    lower_alphabet[shfted_index]
  elsif upper_alphabet.include?(char)
    shfted_index = upper_alphabet.index(char) + shft_int
    if shfted_index < 0
      shfted_index += 26
    elsif shfted_index > 26
      shfted_index -= 26
    end
    upper_alphabet[shfted_index]
  else
    char
  end
  }
  shfted_str = shfted_str_arr.join("")
end

post '/caesar' do
  @word = params["word"]
  @shift = params["shift"]

  @encoded = caesar_cipher(@word, @shift)
  erb :caesar
end




