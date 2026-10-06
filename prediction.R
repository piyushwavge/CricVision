calculate_win_probability <- function(
    team1,
    team2,
    format,
    venue,
    toss_winner,
    toss_decision,
    pitch_type
) {
  
  get_team_strength <- function(team) {
    
    bat <- cricket_data$batsmen %>%
      filter(Country == team)
    
    bowl <- cricket_data$bowlers %>%
      filter(Country == team)
    
    if (format == "ODI") {
      
      bat_avg <- mean(bat$Average_ODI, na.rm = TRUE)
      bat_sr <- mean(bat$SR_ODI, na.rm = TRUE)
      bowl_wkt <- mean(bowl$Wickets_ODI, na.rm = TRUE)
      bowl_eco <- mean(bowl$Economy_ODI, na.rm = TRUE)
      
    } else if (format == "T20") {
      
      bat_avg <- mean(bat$Average_T20, na.rm = TRUE)
      bat_sr <- mean(bat$SR_T20, na.rm = TRUE)
      bowl_wkt <- mean(bowl$Wickets_T20, na.rm = TRUE)
      bowl_eco <- mean(bowl$Economy_T20, na.rm = TRUE)
      
    } else {
      
      bat_avg <- mean(bat$Average_Test, na.rm = TRUE)
      bat_sr <- mean(bat$SR_Test, na.rm = TRUE)
      bowl_wkt <- mean(bowl$Wickets_Test, na.rm = TRUE)
      bowl_eco <- mean(bowl$Economy_Test, na.rm = TRUE)
    }
    
    values <- c(
      bat_avg,
      bat_sr,
      bowl_wkt,
      bowl_eco
    )
    
    values[is.na(values)] <- 0
    
    batting_score <-
      min(bat_avg / 50, 1) * 40 +
      min(bat_sr / 150, 1) * 25
    
    bowling_score <-
      min(bowl_wkt / 100, 1) * 25
    
    economy_score <- if (bowl_eco > 0) {
      max(0, min((10 - bowl_eco) / 6, 1)) * 10
    } else {
      0
    }
    
    batting_score +
      bowling_score +
      economy_score
  }
  
  
  strength1 <- get_team_strength(team1)
  strength2 <- get_team_strength(team2)
  
  if (strength1 <= 0) strength1 <- 50
  if (strength2 <= 0) strength2 <- 50
  
  total_strength <- strength1 + strength2
  
  team1_base <-
    (strength1 / total_strength) * 100
  
  team2_base <-
    (strength2 / total_strength) * 100
  
  
  toss_effect <- 0
  
  if (!is.null(toss_winner) &&
      !is.na(toss_winner)) {
    
    if (toss_winner == team1) {
      toss_effect <- 5
    }
    
    if (toss_winner == team2) {
      toss_effect <- -5
    }
    
    if (toss_decision == "Bowl") {
      toss_effect <- toss_effect * 0.8
    }
  }
  
  
  pitch_effect <- 0
  
  if (!is.null(pitch_type) &&
      !is.na(pitch_type)) {
    
    if (pitch_type == "Batting") {
      pitch_effect <- 2
    }
    
    if (pitch_type == "Bowling") {
      pitch_effect <- -2
    }
    
    if (pitch_type == "Balanced") {
      pitch_effect <- 0
    }
  }
  
  
  venue_effect <- 0
  
  if (!is.null(venue) &&
      !is.na(venue)) {
    
    history <- cricket_data$match_history
    
    if ("Venue" %in% names(history)) {
      
      venue_data <- history %>%
        filter(Venue == venue)
      
      if (nrow(venue_data) > 0) {
        
        team1_matches <- venue_data %>%
          filter(
            Team1 == team1 |
              Team2 == team1
          )
        
        team2_matches <- venue_data %>%
          filter(
            Team1 == team2 |
              Team2 == team2
          )
        
        team1_wins <- sum(
          (
            team1_matches$Winner_Team == "Team1" &
              team1_matches$Team1 == team1
          ) |
            (
              team1_matches$Winner_Team == "Team2" &
                team1_matches$Team2 == team1
            ),
          na.rm = TRUE
        )
        
        team2_wins <- sum(
          (
            team2_matches$Winner_Team == "Team1" &
              team2_matches$Team1 == team2
          ) |
            (
              team2_matches$Winner_Team == "Team2" &
                team2_matches$Team2 == team2
            ),
          na.rm = TRUE
        )
        
        if (team1_wins > team2_wins) {
          venue_effect <- 3
        }
        
        if (team2_wins > team1_wins) {
          venue_effect <- -3
        }
      }
    }
  }
  
  
  final_team1 <-
    team1_base +
    toss_effect +
    pitch_effect +
    venue_effect
  
  final_team1 <-
    max(
      min(final_team1, 90),
      10
    )
  
  final_team2 <-
    100 - final_team1
  
  
  final_team1 <-
    round(final_team1, 1)
  
  final_team2 <-
    round(final_team2, 1)
  
  
  strength_factor <-
    round(team1_base - 50, 1)
  
  toss_factor <-
    round(toss_effect, 1)
  
  pitch_factor <-
    round(pitch_effect, 1)
  
  venue_factor <-
    round(venue_effect, 1)
  
  
  list(
    
    team1_prob = final_team1,
    
    team2_prob = final_team2,
    
    factors = list(
      
      strength = strength_factor,
      
      toss = toss_factor,
      
      pitch = pitch_factor,
      
      venue = venue_factor
    )
  )
}
```

**Bas itna karo:**
  
  1. `CricVision` folder → `prediction.R`
2. Upar wala code paste karo
3. `Ctrl + S`
4. `app.R` mein `source("prediction.R")` hona chahiye
5. App ko stop karke dobara `runApp()` karo.

Prediction UI mein **PREDICT RESULT** button dabane par ye function call hoga.
