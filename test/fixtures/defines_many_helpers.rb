module DogHelper
  include Kibbles
  include Bits
end

module CatHelper
  def help?
    :no
  end
end

module CatHelper
  def no_really_cat_help_me_out!
    :no
  end
end

module Boston::WeatherHelper
  def weather_prediction(month)
    case month
    when JANUARY then :cold
    when FEBRUARY then :quit_yer_complaining_this_is_boston_what_did_you_expect
    when MARCH then :look_spring_is_here_just_kidding
    when APRIL then :surprise_snow_attack
    when MAY then :great_but_somehow_people_still_find_something_to_complain_about
    when JUNE then :mildly_warm
    when JULY then :mildly_warm_but_bostonians_call_it_hot
    when AUGUST then :still_mildly_warm_but_people_act_like_they_are_dying_on_the_streets_from_the_heat
    when SEPTEMBER then :finally_the_only_month_where_no_one_complains_about_the_weather
    when OCTOBER then :omg_new_england_is_so_beautiful_let_us_all_move_to_vermont
    when NOVEMBER then :great_weather_that_is_spoiled_by_people_complaining
    when DECEMBER then :occasional_sleet_that_bostonians_will_call_hail
    end
  end
end

module Massachusetts
  class Driver
    def skill
      :the_best
    end
    def kindness
      :will_actually_stop_for_pedestrians
    end
  end
end
