module Whelper
  class Dog
    def initialize
      $puppies << Puppy.new  # That's right, I'm checking in code with a global variable.
                             # Living on the edge. I am bad to the bone. To quote Pee-wee:
                             #
                             #   There's a lotta things about me you don't know anything
                             #   about, Dottie. Things you wouldn't understand. Things you
                             #   couldn't understand. Things you shouldn't understand.
                             #   You don't wanna get mixed up with a guy like me.
                             #   I'm a loner, Dottie. A rebel. So long, Dott.
    end
  end
end
