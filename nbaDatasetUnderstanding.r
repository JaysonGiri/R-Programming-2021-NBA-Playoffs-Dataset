nba <- nba_players_shooting

# View the data
View(nba)


# Display summary statistics

# head() / tail()
head(nba, 4)
tail(nba, 4)

# summary()
summary(nba)
summary(nba$SCORE)

# Check to see if there are missing data?
sum(is.na(nba))

# skimr() - expands on summary() by providing larger set of statistics
# install.packages("skimr")

library(skimr)
library(dplyr)

skim(nba) # Perform skim to display summary statistics

# Group data by Y (Shot made or missed) then perform skim
nba %>%
  group_by(SCORE) %>% 
  skim()

# Quick Data Visualization
# R base plot()

library(tidyverse)

# Panel plots
plot(nba, col="red")

# Scatter plot
# Looking at all the unique nba players and thier number of occurances
unique(nba$SHOOTER)

nba %>%
  distinct(
    SHOOTER
  )

table(nba$SHOOTER)

ggplot(nba, aes(x = X, y = Y, color = SCORE)) +
  geom_point() +
  labs(title = "Shot Location of all players", x = "X Position", y = "Y Position")

nba %>% 
  filter(SHOOTER == "Trae Young") %>% 
  ggplot(aes(x = X, y = Y, color = SCORE)) +
  geom_point() +
  labs(title = "Shot Location - Trae Young", x = "X Position", y = "Y Position")

nba %>% 
  filter(SHOOTER == "Chris Paul") %>% 
  ggplot(aes(x = X, y = Y, color = SCORE)) +
  geom_point() +
  labs(title = "Shot Location - Chris Paul", x = "X Position", y = "Y Position")

nba %>% 
  filter(SHOOTER == "Russell Westbrook") %>% 
  ggplot(aes(x = X, y = Y, color = SCORE)) +
  geom_point() +
  labs(title = "Shot Location - Russell Westbrook", x = "X Position", y = "Y Position")

nba %>% 
  filter(SHOOTER == "Seth Curry") %>% 
  ggplot(aes(x = X, y = Y, color = SCORE)) +
  geom_point() +
  labs(title = "Shot Location - Seth Curry", x = "X Position", y = "Y Position")

# Bar Graph
# Looking at the range from where shots are taken and how different players are more dominant at each range
ggplot(nba, aes(x = RANGE, fill = SCORE)) +
  geom_bar(position = "dodge") +
  labs(title = "Shot count of each range from all players", x = "Range", y = "Count")

nba %>% 
  filter(SHOOTER == "Seth Curry") %>% 
  ggplot(aes(x = RANGE, fill = SCORE)) +
  geom_bar(position = "dodge") +
  labs(title = "Shot Count of each Range - Seth Curry", x = "Range", y = "Count")

nba %>% 
  filter(SHOOTER == "Trae Young") %>% 
  ggplot(aes(x = RANGE, fill = SCORE)) +
  geom_bar(position = "dodge") +
  labs(title = "Shot Count of each Range - Trae Young", x = "Range", y = "Count")

nba %>% 
  filter(SHOOTER == "Chris Paul") %>% 
  ggplot(aes(x = RANGE, fill = SCORE)) +
  geom_bar(position = "dodge") +
  labs(title = "Shot Count of each Range - Chris Paul", x = "Range", y = "Count")

nba %>% 
  filter(SHOOTER == "Russell Westbrook") %>% 
  ggplot(aes(x = RANGE, fill = SCORE)) +
  geom_bar(position = "dodge") +
  labs(title = "Shot Count of each Range - Russell Westbrook", x = "Range", y = "Count")


# Histogram
hist(nba$X,col = "red")

ggplot(nba, aes(x = Y, color = SHOOTER)) + 
  geom_histogram() +
  labs(x = "Y Location")

# Box Plot

nba_long <- pivot_longer(nba, cols = 3:4, names_to = "Feature", values_to = "Value")
# pivot_longer() converts wide data to long format

ggplot(nba_long, aes(x = SCORE, y = Value)) +
  geom_boxplot() +
  facet_wrap(~Feature, scales = "free_y") # creates one boxplot per feature in a grid, similar to featurePlot
# scales = "free_y" allows each feature to use its own y-axis scale

# Answering some questions

# 1. What is the best shooting position for each player?
# Summarize shooting data by player and position
best_positions <- nba %>% 
  group_by(SHOOTER, RANGE) %>% 
  summarise(
    shots_made = sum(SCORE == "MADE"),
    total_shots = n(),
    shooting_percentage = shots_made / total_shots,
    .groups = "drop"
  )

View(best_positions)

# Find the best shooting position for each player
best_for_each_player <- best_positions %>% 
  group_by(SHOOTER) %>% 
  filter(shooting_percentage == max(shooting_percentage)) %>% 
  arrange(SHOOTER)

View(best_for_each_player)
print(best_for_each_player)


ggplot(best_for_each_player, aes(x = SHOOTER, y = shooting_percentage, fill = RANGE)) +
  geom_col() +
  coord_flip() +
  labs(title = "Best Shooting Position for Each Player", x = "Player", y = "Shooting Percentage")

# 2. At what range each player is most likely to score a shot?

best_player_by_range <- best_positions %>% 
  group_by(RANGE) %>% 
  filter(shooting_percentage == max(shooting_percentage)) %>% 
  arrange(RANGE)

print(best_player_by_range)

ggplot(best_player_by_range, aes(x = RANGE, y = shooting_percentage, fill = SHOOTER)) +
  geom_col() +
  coord_flip() +
  labs(title = "Best Shooter at each range", x = "Range", y = "Shooting Percentage")

# 3. Who of these players is the best defender?
# Summarize opponent shooting vs each defender
defensive_stats <- nba %>% 
  group_by(DEFENDER) %>% 
  summarise(
    shots_guarded = n(),
    shots_made = sum(SCORE == "MADE"),
    shots_missed = sum(SCORE == "MISSED"),
    opponent_field_goal_percentage = shots_made / shots_guarded,
    .groups = "drop"
  ) %>% 
  arrange(opponent_field_goal_percentage) # lower is better

head(defensive_stats)  

best_defender <- defensive_stats %>% 
  slice_min(opponent_field_goal_percentage, n = 1)

best_defender

ggplot(defensive_stats, aes(x = reorder(DEFENDER, opponent_field_goal_percentage), y = opponent_field_goal_percentage)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Opponent Field Goal Percentage by Defender", x = "Defender", y = "Opponent Field Goal Percentage")

# 4. On whom of these player would you put the best defender?

offensive_stats <- nba %>% 
  group_by(SHOOTER) %>% 
  summarise(
    shots_taken = n(),
    shots_made = sum(SCORE == "MADE"),
    shots_missed = sum(SCORE == "MISSED"),
    field_goal_percentage = shots_made / shots_taken,
    .groups = "drop"
  ) %>% 
  arrange(desc(field_goal_percentage))

top_shooter <- offensive_stats %>% 
  slice_max(field_goal_percentage, n = 1)

top_shooter

ggplot(offensive_stats, aes(x = reorder(SHOOTER, field_goal_percentage), y = field_goal_percentage)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Field Goal Percentage by Shooter", x = "Shooter", y = "Field Goal Percentage")

# 5. Do the efficiency of a shooter and the player defending him correlate?
# Now lets compare Seth Curry against all the defenders especially Russell Westbrook
seth_defenders_stats <- nba %>% 
  filter(SHOOTER == "Seth Curry", DEFENDER != "Seth Curry") %>% 
  group_by(DEFENDER) %>% 
  summarise(
    shots_taken = n(),
    shots_made = sum(SCORE == "MADE"),
    shots_missed = sum(SCORE == "MISSED"),
    field_goal_percentage = shots_made / shots_taken,
    .groups = "drop"
  ) %>% 
  arrange(desc(field_goal_percentage))

seth_defenders_stats

ggplot(seth_defenders_stats, aes(x = reorder(DEFENDER, field_goal_percentage), y = field_goal_percentage)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Field Goal Percentage of Seth Curry VS Each Defender", x = "Defender", y = "Field Goal Percentage")

# Worst shooting position of each player
# Summarize shooting data by player and position
worst_positions <- nba %>% 
  group_by(SHOOTER, RANGE) %>% 
  summarise(
    shots_missed = sum(SCORE == "MISSED"),
    total_shots = n(),
    miss_percentage = shots_missed / total_shots,
    .groups = "drop"
  )

worst_positions

# Find the best shooting position for each player
worst_for_each_player <- worst_positions %>% 
  group_by(SHOOTER) %>% 
  filter(miss_percentage == max(miss_percentage)) %>% 
  arrange(SHOOTER)

worst_for_each_player


ggplot(worst_for_each_player, aes(x = SHOOTER, y = miss_percentage, fill = RANGE)) +
  geom_col() +
  coord_flip() +
  labs(title = "Worst Shooting Position for Each Player", x = "Player", y = "Miss Percentage")

# Shooting positions and shooting percentages
range_shooting <- nba %>% 
  group_by(RANGE) %>% 
  summarise(
    shots_made = sum(SCORE == "MADE"),
    total_shots = n(),
    shot_percentage = shots_made / total_shots,
    .groups = "drop"
  )

range_shooting

ggplot(range_shooting, aes(x = RANGE, y = shot_percentage, fill = "red")) +
  geom_col() +
  coord_flip() +
  labs(title = "Shooting percentage by range", x = "Range", y = "Shoot Percentage")
