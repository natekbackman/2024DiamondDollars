# hitters
savant <- read.csv("SABR Case Comp/savant_batting_2015-2023.csv") %>% 
  filter(year == 2023)

# batter WPA
data %>% 
  filter(game_year == 2023) %>% 
  drop_na(delta_home_win_exp) %>% 
  mutate(wpa = ifelse(inning_topbot == "Top",
                      delta_home_win_exp * -1,
                      delta_home_win_exp)) %>% 
  group_by(batter) %>% 
  summarise(hitter_wpa = sum(wpa),
            n_obs_wpa = n()) %>% 
  ungroup() -> hitter_wpa

# average ab length
data %>% 
  filter(game_year == 2023) %>% 
  drop_na(events) %>% 
  group_by(batter) %>% 
  summarise(avg_ab_len = sum(pitch_number) / n(),
            n_ab = n()) %>% 
  ungroup() -> hitter_ab_len

# two strike fouls
data %>% 
  filter(game_year == 2023 &
           description == "foul") %>% 
  group_by(batter) %>% 
  summarise(avg_two_s_foul = sum(strikes == 2) / n(),
            n_two_s_foul = sum(strikes == 2),
            n_ab = n()) %>% 
  ungroup() -> hitter_two_strike

hitter_features <- c("oz_contact_percent", "oz_swing_percent", "pa",
                     "swing_percent")

fopa_hitter <- readRDS("fopa_hitter.rds")

# hitter dataset w/ fopa
savant %>% 
  dplyr::select(player_id, all_of(hitter_features),
                last_name..first_name) %>% 
  left_join(fopa_hitter, by = c("player_id" = "batter")) %>% 
  left_join(hitter_wpa, by = c("player_id" = "batter")) %>% 
  left_join(hitter_ab_len, by = c("player_id" = "batter")) %>% 
  left_join(hitter_two_strike, by = c("player_id" = "batter")) %>% 
  mutate(fopa_per_pa = fopa / pa,
         fopa_per_fb = fopa / n_obs,
         fb_per_pa = n_obs / pa) -> hitter_data

write.csv(hitter_data, "hitter_data.csv")

# pitchers
savant <- read.csv("SABR Case Comp/savant_pitching_2015-2023.csv") %>% 
  filter(year == 2023)

# pitcher WPA
data %>% 
  filter(game_year == 2023) %>% 
  drop_na(delta_home_win_exp) %>% 
  mutate(wpa = ifelse(inning_topbot == "Top",
                      delta_home_win_exp,
                      delta_home_win_exp * -1)) %>% 
  group_by(pitcher) %>% 
  summarise(pitcher_wpa = sum(wpa),
            n_obs_wpa = n()) %>% 
  ungroup() -> pitcher_wpa

# average ab length
data %>% 
  filter(game_year == 2023) %>% 
  drop_na(events) %>% 
  group_by(pitcher) %>% 
  summarise(avg_ab_len = sum(pitch_number) / n(),
            n_ab = n()) %>% 
  ungroup() -> pitcher_ab_len

# two strike fouls
data %>% 
  filter(game_year == 2023 &
           description == "foul") %>% 
  group_by(pitcher) %>% 
  summarise(avg_two_s_foul = sum(strikes == 2) / n(),
            n_two_s_foul = sum(strikes == 2),
            n_ab = n()) %>% 
  ungroup() -> pitcher_two_strike

pitcher_features <- c("bb_percent", "oz_swing_percent",
                      "oz_contact_percent", "pa")

fopa_pitcher <- readRDS("fopa_pitcher.rds")

# pitcher dataset w/ fopa
savant %>% 
  dplyr::select(player_id, all_of(pitcher_features),
                last_name..first_name) %>% 
  left_join(fopa_pitcher, by = c("player_id" = "pitcher")) %>% 
  left_join(pitcher_wpa, by = c("player_id" = "pitcher")) %>% 
  left_join(pitcher_ab_len, by = c("player_id" = "pitcher")) %>% 
  left_join(pitcher_two_strike, by = c("player_id" = "pitcher")) %>% 
  mutate(fopa_per_pa = fopa / pa,
         fopa_per_fb = fopa / n_obs,
         fb_per_pa = n_obs / pa) -> pitcher_data

write.csv(pitcher_data, "pitcher_data.csv")

# app plot code
hitter_data %>% 
  filter(n_obs >= 100) %>% 
  ggplot(aes(x = avg_two_s_foul, y = fopa, color = n_obs)) +
  geom_point() +
  theme_bw(base_family = "serif") +
  labs(title = "Batter FOPA vs Two Strike Foul %",
       subtitle = "Minimum 100 Foul Balls",
       color = "# Foul Balls") +
  xlab("Two Strike Foul %") +
  ylab("Batter FOPA") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

pitcher_data %>% 
  filter(n_obs >= 100) %>% 
  ggplot(aes(x = oz_swing_percent, y = fopa, color = n_obs)) +
  geom_point() +
  theme_bw(base_family = "serif") +
  labs(title = "Pitcher FOPA vs Two Strike Foul %",
       subtitle = "Minimum 100 Foul Balls",
       color = "# Foul Balls") +
  xlab("Two Strike Foul %") +
  ylab("Pitcher FOPA") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))

# rolling fopa
fopa_hitter_pbp %>% 
  filter(batter == 673490) %>% 
  arrange(desc(game_pk), at_bat_number, pitch_number) %>% 
  mutate(game_date = as.Date(game_date, "%m/%d/%Y"),
         row_number = row_number()) %>% 
  ggplot(aes(x = row_number, y = cumsum(out_prob_added))) +
  geom_line()

fopa_pitcher_pbp %>% 
  filter(pitcher == 669923) %>% 
  arrange(desc(game_pk), at_bat_number, pitch_number) %>% 
  mutate(game_date = as.Date(game_date, "%m/%d/%Y"),
         row_number = row_number()) %>% 
  ggplot(aes(x = row_number, y = cumsum(out_prob_added))) +
  geom_line()
