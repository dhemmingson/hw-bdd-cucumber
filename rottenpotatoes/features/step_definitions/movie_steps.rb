
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create! movie
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  
  fail "Unimplemented"
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check("ratings_#{field}")
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck("ratings_#{field}")
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  rating_list.split(', ').each do |rating| 
    if uncheck
      uncheck "ratings_#{rating}"
    else
      check "ratings_#{rating}"
    end
  end
end

Then /I should( not)? see the following movies/ do |should_not, movie_table|
  movie_table.raw.flatten.each do |movie|
    if should_not
      expect(page).to have_no_content(movie)
    else
      expect(page).to have_content(movie)
    end
  end
end

Then /I should see all of the movies/ do
  all_movies = Movie.pluck(:title)
  # Make sure that all the movies in the app are visible in the table
  all_movies.each { |movie| expect(page).to have_content(movie) }
end
