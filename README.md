# A simple tester for philo project in 42 cursus
![image](https://user-images.githubusercontent.com/52115261/209983776-b02ccb8a-24d5-47ab-9403-6277e978e91c.png)
Its a simple script in shell mean to test few aspest of your philo programs.
For now it doesnt check for leak, dead lock, data race but its comming in the near future

It will check :
- Basic parsing
- Infinite situation
- Situation where a philo should died after X ms
- Situation where all philo need to eat at least X time

# IMPORTANT
This is **not** mean to be used in a correction. If a test failed you need to find why in the corrected code and to justified why its false.
# How to launch it :
Usage : ./tester.sh <path_to_philo_folder>
Exemple : ./tester.sh ..or ./tester.sh ~/work42/philo

# Thank to 
[@newlinuxbot](https://github.com/newlinuxbot) for its OG tester, mine is deeply inspired by [his](https://github.com/newlinuxbot/Philosphers-42Project-Tester) tester

[@mcombeau](https://github.com/mcombeau/) for his great article on philosophers
