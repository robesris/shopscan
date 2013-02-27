shopscan
========

A very simple ruby API exercise.

install and run rspec tests
===========================

git clone git://github.com/robesris/shopscan.git  
cd shopscan  
bundle install  
  
\# set LIST_LENGTH to any non-negative number to test all permutations of that length (default is 1)    
LIST_LENGTH=5 bundle exec rspec -fd  
