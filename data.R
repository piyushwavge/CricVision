# ============================================================
# data.R — Realistic Cricket Dataset (Real Player Stats)
# ============================================================

generate_cricket_data <- function() {
  
  # ── BATTING DATA ──────────────────────────────────────────
  batsmen <- data.frame(
    Player = c(
      "Virat Kohli","Rohit Sharma","KL Rahul","Shubman Gill",
      "Suryakumar Yadav","Hardik Pandya","Rishabh Pant","Ishan Kishan",
      "Steve Smith","David Warner","Marnus Labuschagne","Travis Head",
      "Joe Root","Ben Stokes","Jonny Bairstow","Jos Buttler",
      "Babar Azam","Mohammad Rizwan","Fakhar Zaman","Imam-ul-Haq",
      "Kane Williamson","Devon Conway","Finn Allen","Martin Guptill",
      "Quinton de Kock","Temba Bavuma","Rassie van der Dussen","David Miller",
      "Dimuth Karunaratne","Pathum Nissanka","Kusal Mendis","Charith Asalanka",
      "Litton Das","Najmul Hossain Shanto","Tamim Iqbal","Mushfiqur Rahim",
      "Dasun Shanaka","Angelo Mathews","Dhananjaya de Silva","Kamindu Mendis"
    ),
    
    Country = c(
      rep("India",8), rep("Australia",4), rep("England",4),
      rep("Pakistan",4), rep("New Zealand",4), rep("South Africa",4),
      rep("Sri Lanka",4), rep("Bangladesh",4), rep("Sri Lanka",4)
    ),
    
    Format = rep("All Formats",40),
    
    Matches_ODI = c(
      274,250,67,47,61,73,33,35,
      162,161,82,59,
      185,110,149,161,
      120,95,73,78,
      160,67,25,198,
      143,96,62,124,
      158,49,78,56,
      68,59,228,93,
      72,244,82,28
    ),
    
    Runs_ODI = c(
      13848,10709,2417,2483,1981,1864,857,1188,
      7227,6932,3425,2472,
      9752,3194,5072,4120,
      6115,3979,3598,3552,
      8703,2562,738,7346,
      8671,2887,2437,4655,
      5762,1693,2723,1624,
      2266,2159,8357,3278,
      2438,7957,2720,876
    ),
    
    Average_ODI = c(
      57.32,48.96,45.60,56.43,45.60,30.56,31.74,39.60,
      44.37,45.30,52.68,49.44,
      53.57,38.34,39.31,34.83,
      57.68,45.79,52.17,49.33,
      44.71,45.78,34.56,35.20,
      44.62,35.46,47.78,40.48,
      35.11,42.33,39.17,32.48,
      34.33,42.33,36.27,36.42,
      37.50,39.98,35.32,38.96
    ),
    
    SR_ODI = c(
      93.17,89.77,88.65,100.14,119.38,104.58,122.37,96.34,
      83.59,87.01,76.37,107.53,
      88.92,93.16,96.44,118.91,
      88.04,82.52,95.09,84.33,
      80.25,81.72,133.57,79.99,
      96.61,73.40,84.57,130.21,
      80.41,93.87,89.77,95.15,
      83.15,89.35,82.21,78.62,
      98.75,76.82,86.37,97.82
    ),
    
    Hundreds_ODI = c(
      50,31,5,8,4,2,0,5,
      12,18,8,6,
      23,5,11,10,
      20,9,10,10,
      17,6,0,18,
      17,4,7,9,
      14,4,8,3,
      5,4,25,8,
      4,19,6,1
    ),
    
    Fifties_ODI = c(
      72,52,17,14,15,14,7,9,
      45,33,18,14,
      60,25,43,34,
      29,31,21,25,
      52,19,3,39,
      46,21,15,32,
      49,13,17,11,
      17,15,50,24,
      20,53,16,8
    ),
    
    HS_ODI = c(
      183,264,112,208,156,148,125,173,
      164,179,154,142,
      180,182,141,150,
      158,131,210,100,
      200,99,101,237,
      178,141,134,162,
      144,137,162,121,
      116,114,158,144,
      127,128,119,93
    ),
    
    Matches_T20 = c(
      117,151,73,50,74,89,66,58,
      55,105,33,46,
      113,54,87,112,
      121,109,51,61,
      107,51,48,101,
      121,46,38,116,
      87,42,60,51,
      67,54,108,94,
      58,107,48,19
    ),
    
    Runs_T20 = c(
      4188,4231,2265,1986,3479,1584,987,1514,
      1447,2265,953,1628,
      1908,1286,2614,3582,
      4012,2957,1827,1596,
      2265,1590,1359,3531,
      2923,1293,1028,2584,
      1947,1423,2088,1742,
      1966,1764,3001,2488,
      1628,2069,1598,642
    ),
    
    Average_T20 = c(
      52.65,31.41,37.75,47.28,47.65,27.96,22.43,30.90,
      33.65,34.31,37.09,45.22,
      36.69,28.57,33.51,37.31,
      40.52,34.38,42.48,32.57,
      34.09,36.87,32.35,35.66,
      27.08,33.15,31.15,31.26,
      27.42,39.52,40.15,38.71,
      32.74,36.75,31.26,30.46,
      30.69,24.34,39.95,36.78
    ),
    
    SR_T20 = c(
      137.76,140.89,135.72,148.65,172.51,146.02,128.69,126.52,
      125.13,140.82,118.22,155.04,
      124.50,136.45,129.37,157.59,
      129.08,128.38,141.29,117.82,
      118.67,128.52,168.76,135.22,
      138.58,117.22,128.14,153.61,
      119.52,142.65,148.22,145.38,
      121.45,137.82,120.54,118.37,
      148.57,116.28,142.37,150.98
    ),
    
    Matches_Test = c(
      113,55,45,14,
      6,11,33,5,
      102,112,58,44,
      179,95,97,56,
      92,44,5,23,
      103,25,3,47,
      100,13,41,14,
      104,19,41,23,
      63,31,70,88,
      31,104,55,3
    ),
    
    Runs_Test = c(
      9144,3442,2071,824,
      138,525,3018,124,
      9490,8695,4534,2611,
      13005,6657,6620,2611,
      10138,2117,183,1154,
      8607,1523,83,2586,
      7289,542,2524,627,
      6109,1233,2611,1012,
      2812,1367,5134,5446,
      1324,6068,2572,189
    ),
    
    Average_Test = c(
      49.15,44.76,44.10,56.44,
      23.00,30.88,43.11,24.80,
      61.37,44.59,55.29,49.26,
      54.39,36.98,40.37,32.18,
      51.96,34.06,22.88,36.06,
      56.90,44.79,41.50,38.00,
      47.34,41.69,48.54,47.85,
      38.90,38.53,44.17,35.07,
      34.29,36.94,38.60,38.77,
      34.97,40.72,37.82,37.80
    ),
    
    Wickets_ODI = c(
      4,8,0,0,0,67,0,0,3,5,0,2,12,95,4,8,
      0,0,0,0,0,0,0,2,5,2,0,121,0,0,0,81,1,0,1,5,158,140,111,36
    ),
    
    Economy_ODI = c(
      6.0,6.0,NA,NA,NA,5.5,NA,NA,
      5.5,6.2,NA,7.1,5.5,5.0,6.5,6.2,
      NA,NA,NA,NA,NA,NA,NA,4.5,
      6.2,5.5,NA,5.2,NA,NA,NA,5.8,
      6.5,NA,7.2,5.5,5.2,5.0,4.8,5.5
    ),
    
    Age = c(
      35,37,32,25,33,30,26,26,
      35,38,30,30,33,32,34,33,
      29,32,33,28,33,32,25,38,
      31,33,32,34,36,27,29,26,
      30,27,34,36,32,41,35,24
    ),
    
    Role = c(
      "Batsman","Batsman","Batsman","Batsman",
      "Batsman","All-Rounder","WK-Batsman","WK-Batsman",
      "Batsman","Batsman","Batsman","Batsman",
      "Batsman","All-Rounder","WK-Batsman","WK-Batsman",
      "Batsman","WK-Batsman","Batsman","Batsman",
      "Batsman","WK-Batsman","Batsman","Batsman",
      "WK-Batsman","Batsman","Batsman","All-Rounder",
      "Batsman","Batsman","WK-Batsman","Batsman",
      "WK-Batsman","Batsman","Batsman","WK-Batsman",
      "All-Rounder","Batsman","All-Rounder","Batsman"
    ),
    
    Batting_Style = c(
      "Right","Right","Right","Right","Right","Right","Left","Left",
      "Right","Left","Right","Left","Right","Left","Right","Right",
      "Right","Right","Left","Left","Right","Left","Right","Right",
      "Left","Right","Right","Left","Right","Right","Right","Left",
      "Left","Left","Left","Right","Right","Right","Right","Left"
    ),
    
    stringsAsFactors = FALSE
  )
  
  # ── BOWLING DATA ──────────────────────────────────────────
  bowlers <- data.frame(
    Player = c(
      "Jasprit Bumrah","Mohammed Shami","Ravindra Jadeja","R. Ashwin",
      "Hardik Pandya","Kuldeep Yadav","Yuzvendra Chahal","Mohammed Siraj",
      "Pat Cummins","Mitchell Starc","Josh Hazlewood","Adam Zampa",
      "Stuart Broad","James Anderson","Mark Wood","Adil Rashid",
      "Shaheen Afridi","Haris Rauf","Naseem Shah","Shadab Khan",
      "Trent Boult","Tim Southee","Kyle Jamieson","Mitchell Santner",
      "Kagiso Rabada","Anrich Nortje","Lungi Ngidi","Keshav Maharaj",
      "Lasith Kumara","Dushmantha Chameera","Maheesh Theekshana","Wanindu Hasaranga",
      "Mustafizur Rahman","Taskin Ahmed","Shakib Al Hasan","Mehidy Hasan",
      "Matthew Forde","Romario Shepherd","Jason Holder","Alzarri Joseph"
    ),
    
    Country = c(
      rep("India",8), rep("Australia",4), rep("England",4),
      rep("Pakistan",4), rep("New Zealand",4), rep("South Africa",4),
      rep("Sri Lanka",4), rep("Bangladesh",4), rep("West Indies",4)
    ),
    
    Bowling_Style = c(
      "RF","RFM","SLA","OB","RFM","LSC","LBG","RFM",
      "RFM","LF","RFM","LBG","RFM","RFM","RF","LBG",
      "LF","RF","RF","LBG","LFM","RFM","RFM","SLA",
      "RF","RF","RFM","OB","RF","RF","OB","LBG",
      "LFM","RFM","SLA","OB","RF","RFM","RFM","RF"
    ),
    
    Wickets_ODI = c(
      144,195,195,156,67,145,121,88,
      196,235,167,151,153,269,87,155,
      189,130,47,143,169,231,42,125,
      149,54,84,109,148,55,288,135,
      47,63,151,81,47,63,151,81
    ),
    
    Economy_ODI = c(
      4.63,5.26,4.72,4.91,5.50,5.06,5.28,5.43,
      5.13,5.47,5.05,5.48,4.98,4.54,5.68,5.63,
      5.40,6.04,5.67,5.39,4.97,4.99,5.21,4.89,
      4.82,5.50,5.61,4.87,5.71,5.40,6.22,5.36,
      5.08,6.12,4.82,5.37,6.55,5.93,4.87,6.12
    ),
    
    Average_Bowl_ODI = c(
      24.31,26.54,36.11,32.97,30.56,26.83,26.14,28.53,
      28.87,24.51,26.06,33.44,26.73,25.72,28.83,33.92,
      26.38,26.86,28.83,34.97,25.66,28.23,33.25,34.82,
      23.07,30.38,27.56,32.52,28.04,34.98,26.37,22.98,
      27.55,31.22,29.24,37.07,31.04,27.65,29.61,25.23
    ),
    
    SR_Bowl_ODI = c(
      31.53,30.24,46.09,40.29,33.26,31.78,29.72,31.53,
      33.76,26.88,30.93,36.58,32.21,33.98,30.42,36.18,
      29.32,26.69,30.51,38.93,30.93,33.93,38.22,42.71,
      28.72,33.14,29.43,40.09,29.44,38.90,25.45,25.72,
      32.54,30.59,36.34,41.41,28.43,27.99,36.49,24.77
    ),
    
    Wickets_T20 = c(
      89,53,54,52,42,90,96,64,
      53,79,42,75,36,12,43,71,
      109,61,31,89,61,109,13,63,
      37,23,41,56,91,42,91,102,
      87,43,141,50,29,32,65,53
    ),
    
    Economy_T20 = c(
      6.33,8.21,7.14,6.97,8.52,7.50,8.21,8.23,
      7.56,8.22,7.71,7.11,8.12,9.85,9.39,7.58,
      7.89,9.37,8.48,8.42,7.39,7.60,8.13,6.50,
      8.09,8.88,8.77,7.88,8.19,8.79,6.72,6.76,
      7.35,8.45,7.39,7.30,8.81,7.83,8.14,9.21
    ),
    
    Wickets_Test = c(
      164,229,290,516,11,10,2,43,
      248,340,177,0,604,696,50,0,
      10,4,32,2,317,368,49,56,
      12,10,46,140,52,37,31,84,
      27,13,698,246,8,12,157,33
    ),
    
    Best_Bowling = c(
      "6/19","9/16","7/48","7/59","3/21","5/24","6/25","6/21",
      "5/28","6/28","5/30","6/30","8/15","7/42","6/26","5/35",
      "6/35","5/38","4/41","5/45","6/30","7/33","5/37","5/50",
      "7/112","6/27","4/31","7/40","6/44","5/28","5/17","6/5",
      "6/43","5/68","7/36","7/58","5/27","4/28","6/42","6/35"
    ),
    
    Age = c(
      30,33,35,37,30,29,33,30,31,33,33,31,
      38,41,34,35,24,30,21,25,34,35,28,31,
      28,29,30,33,30,33,26,26,29,27,36,26,
      25,26,32,26
    ),
    
    Role = c(
      "Bowler","Bowler","All-Rounder","All-Rounder",
      "All-Rounder","Bowler","Bowler","Bowler",
      "All-Rounder","Bowler","Bowler","Bowler",
      "Bowler","Bowler","Bowler","Bowler",
      "Bowler","Bowler","Bowler","All-Rounder",
      "Bowler","Bowler","All-Rounder","All-Rounder",
      "Bowler","Bowler","Bowler","All-Rounder",
      "Bowler","Bowler","Bowler","All-Rounder",
      "Bowler","Bowler","All-Rounder","Bowler",
      "Bowler","Bowler","All-Rounder","Bowler"
    ),
    
    stringsAsFactors = FALSE
  )
  
  # ── MATCH HISTORY ─────────────────────────────────────────
  set.seed(42)
  
  n_matches <- 300
  
  teams <- c(
    "India","Australia","England","Pakistan","New Zealand",
    "South Africa","Sri Lanka","Bangladesh","West Indies","Afghanistan"
  )
  
  formats <- c("ODI","T20I","Test")
  
  match_history <- data.frame(
    Match_ID = 1:n_matches,
    Team1 = sample(teams, n_matches, replace = TRUE),
    Team2 = sample(teams, n_matches, replace = TRUE),
    Format = sample(
      formats,
      n_matches,
      replace = TRUE,
      prob = c(.4,.4,.2)
    ),
    Venue = sample(
      c(
        "Wankhede","MCG","Lord's","Eden Gardens","Oval","SCG",
        "Newlands","Gaddafi","Headingley","SuperSport Park"
      ),
      n_matches,
      replace = TRUE
    ),
    Team1_Score = round(runif(n_matches, 100, 400)),
    Team2_Score = round(runif(n_matches, 80, 380)),
    Toss_Winner = sample(
      c("Team1","Team2"),
      n_matches,
      replace = TRUE
    ),
    Toss_Decision = sample(
      c("bat","field"),
      n_matches,
      replace = TRUE
    ),
    Winner_Team = sample(
      c("Team1","Team2","Draw"),
      n_matches,
      replace = TRUE,
      prob = c(.45,.45,.1)
    ),
    Pitch_Type = sample(
      c("Flat","Green","Dusty","Bouncy","Spin-friendly"),
      n_matches,
      replace = TRUE
    ),
    Weather = sample(
      c("Clear","Overcast","Humid","Windy"),
      n_matches,
      replace = TRUE
    ),
    Year = sample(
      2015:2024,
      n_matches,
      replace = TRUE
    ),
    stringsAsFactors = FALSE
  )
  
  match_history$Team1[
    match_history$Team1 == match_history$Team2
  ] <- "Afghanistan"
  
  list(
    batsmen = batsmen,
    bowlers = bowlers,
    match_history = match_history
  )
}
