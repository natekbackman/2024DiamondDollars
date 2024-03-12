# SABR Diamond Dollars 2024

Project worked on for the 2024 Diamond Dollars Case Competition hosted at the SABR Analytics Conference.

# Case Requirements:

Per SABR:
"Your goal is to establish a set of criteria that will enable you to create a metric that defines if a given foul ball is a benefit to the hitter or pitcher, and by how much."

# Our Approach and Analysis:

We framed our metric within the idea of how much a foul ball is adding to or subtracting from the probability that an out occurs within the at bat. Elements such as the count, the location of the pitch, and the deception of the pitch were all factors that were taken into account in our metric. Thus, our metric was called "Foul Ball Out Probability Added" (FOPA).

# Data:

The data used to create FOPA was Statcast pitch level data from 2020 to 2023 provided by Baseball Savant, scraped through baseballr. Season level Statcast data was used to compare FOPA to other notable season level stats.

# Metric Analysis:

The full 2023 FOPA leaderboards and player/team analysis can be found on an app created for this specific project: https://jjbalek.shinyapps.io/Case_Comp_Shiny_App/
App was developed by Jake Balek
