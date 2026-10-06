library(shiny)
library(shinydashboard)
library(shinyWidgets)

ui <- dashboardPage(
  skin = "black",
  
  dashboardHeader(
    title = tags$span(
      tags$img(
        src = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Cricket_ball.svg/60px-Cricket_ball.svg.png",
        height = "28px",
        style = "margin-right:8px; vertical-align:middle;"
      ),
      tags$b(
        "CricVision",
        style = "color:#FFD700; font-size:20px; letter-spacing:2px;"
      ),
      tags$small(
        " Analytics",
        style = "color:#aaa; font-size:12px;"
      )
    ),
    titleWidth = 260
  ),
  
  dashboardSidebar(
    width = 260,
    
    tags$style(HTML("
      .sidebar {
        background: linear-gradient(180deg,#0d1117 0%,#161b22 100%) !important;
      }

      .sidebar-menu > li > a {
        color:#c9d1d9 !important;
        font-weight:500;
        letter-spacing:.5px;
      }

      .sidebar-menu > li.active > a {
        background:linear-gradient(90deg,#FFD700,#ff8c00) !important;
        color:#000 !important;
        border-radius:0 20px 20px 0;
      }

      .sidebar-menu > li > a:hover {
        background:rgba(255,215,0,.15) !important;
        color:#FFD700 !important;
      }

      .skin-black .main-header .logo {
        background:#0d1117 !important;
      }

      .skin-black .main-header .navbar {
        background:#0d1117 !important;
      }

      .main-sidebar {
        background:#0d1117 !important;
      }
    ")),
    
    sidebarMenu(
      id = "tabs",
      
      menuItem(
        "🏏 Overview",
        tabName = "overview",
        icon = icon("home")
      ),
      
      menuItem(
        "🏃 Batsmen Stats",
        tabName = "batsmen",
        icon = icon("chart-bar")
      ),
      
      menuItem(
        "🎳 Bowlers Stats",
        tabName = "bowlers",
        icon = icon("bowling-ball")
      ),
      
      menuItem(
        "⚔️ Compare Players",
        tabName = "compare",
        icon = icon("balance-scale")
      ),
      
      menuItem(
        "🔮 Match Predictor",
        tabName = "predict",
        icon = icon("magic")
      ),
      
      menuItem(
        "🌍 Country Analysis",
        tabName = "country",
        icon = icon("globe")
      ),
      
      menuItem(
        "📈 Performance Trends",
        tabName = "trends",
        icon = icon("line-chart")
      ),
      
      menuItem(
        "🏆 Top Performers",
        tabName = "top",
        icon = icon("trophy")
      ),
      
      menuItem(
        "📋 Match History",
        tabName = "history",
        icon = icon("table")
      )
    ),
    
    tags$hr(
      style = "border-color:#30363d; margin:10px 15px;"
    ),
    
    tags$div(
      style = "padding:10px 15px; color:#8b949e; font-size:11px;",
      
      tags$b(
        "GLOBAL FILTERS",
        style = "color:#FFD700; display:block; margin-bottom:8px;"
      ),
      
      selectInput(
        "global_format",
        "Format",
        choices = c("ODI", "T20", "Test"),
        selected = "ODI",
        width = "100%"
      ),
      
      pickerInput(
        "global_countries",
        "Countries",
        choices = c(
          "India",
          "Australia",
          "England",
          "Pakistan",
          "New Zealand",
          "South Africa",
          "Sri Lanka",
          "Bangladesh",
          "West Indies"
        ),
        selected = c(
          "India",
          "Australia",
          "England",
          "Pakistan",
          "New Zealand"
        ),
        multiple = TRUE,
        options = list(
          `actions-box` = TRUE,
          `live-search` = TRUE,
          style = "btn-outline-warning btn-sm"
        )
      )
    )
  ),
  
  dashboardBody(
    
    tags$head(
      tags$style(HTML("
        body,
        .content-wrapper,
        .right-side {
          background:#0d1117 !important;
          font-family:'Segoe UI','Helvetica Neue',sans-serif;
          color:#c9d1d9;
        }

        .small-box {
          border-radius:12px !important;
          box-shadow:0 4px 20px rgba(0,0,0,.5) !important;
        }

        .small-box:hover {
          transform:translateY(-3px);
          transition:.3s;
        }

        .box {
          background:#161b22 !important;
          border:1px solid #30363d !important;
          border-radius:12px !important;
          box-shadow:0 4px 16px rgba(0,0,0,.4) !important;
          color:#c9d1d9 !important;
        }

        .box-header {
          border-bottom:1px solid #30363d !important;
          color:#FFD700 !important;
        }

        .box-header .box-title {
          color:#FFD700 !important;
          font-weight:700;
          letter-spacing:1px;
        }

        .form-control,
        .selectize-input {
          background:#0d1117 !important;
          color:#c9d1d9 !important;
          border:1px solid #30363d !important;
          border-radius:8px !important;
        }

        .selectize-dropdown {
          background:#161b22 !important;
          border:1px solid #30363d !important;
        }

        .selectize-dropdown-content .option {
          color:#c9d1d9 !important;
        }

        .selectize-dropdown-content .option:hover {
          background:#FFD700 !important;
          color:#000 !important;
        }

        .dataTables_wrapper {
          color:#c9d1d9 !important;
        }

        table.dataTable tbody tr {
          background:#161b22 !important;
          color:#c9d1d9 !important;
        }

        table.dataTable tbody tr:hover {
          background:#1f2937 !important;
        }

        table.dataTable thead th {
          background:#0d1117 !important;
          color:#FFD700 !important;
          border-bottom:2px solid #FFD700 !important;
        }

        .dataTables_filter input,
        .dataTables_length select {
          background:#0d1117 !important;
          color:#c9d1d9 !important;
          border:1px solid #30363d !important;
        }

        .nav-tabs-custom {
          background:transparent !important;
        }

        .nav-tabs-custom > .nav-tabs > li.active > a {
          color:#FFD700 !important;
          border-top:3px solid #FFD700 !important;
        }

        .btn-predict {
          background:linear-gradient(135deg,#FFD700,#ff8c00) !important;
          color:#000 !important;
          font-weight:700 !important;
          border:none !important;
          border-radius:25px !important;
          padding:10px 30px !important;
          font-size:15px !important;
          box-shadow:0 4px 15px rgba(255,215,0,.4) !important;
          letter-spacing:1px;
          text-transform:uppercase;
          transition:.3s !important;
        }

        .btn-predict:hover {
          transform:scale(1.05);
          box-shadow:0 6px 25px rgba(255,215,0,.6) !important;
        }

        .prob-bar-wrap {
          background:#0d1117;
          border-radius:30px;
          overflow:hidden;
          height:28px;
          border:1px solid #30363d;
          margin:6px 0;
        }

        .prob-bar-inner {
          height:100%;
          border-radius:30px;
          display:flex;
          align-items:center;
          padding-left:12px;
          font-weight:700;
          font-size:13px;
        }

        .factor-card {
          background:#0d1117;
          border:1px solid #30363d;
          border-radius:10px;
          padding:10px 14px;
          margin:5px 0;
          display:flex;
          justify-content:space-between;
          align-items:center;
        }

        .factor-badge-pos {
          background:rgba(0,200,100,.2);
          color:#00c864;
          border:1px solid #00c864;
          border-radius:20px;
          padding:2px 10px;
          font-size:12px;
        }

        .factor-badge-neg {
          background:rgba(255,80,80,.2);
          color:#ff5050;
          border:1px solid #ff5050;
          border-radius:20px;
          padding:2px 10px;
          font-size:12px;
        }

        .factor-badge-neu {
          background:rgba(200,200,200,.1);
          color:#aaa;
          border:1px solid #555;
          border-radius:20px;
          padding:2px 10px;
          font-size:12px;
        }

        .radar-title {
          color:#FFD700;
          font-weight:700;
          text-align:center;
          margin-bottom:10px;
        }

        .content-header h1 {
          color:#FFD700 !important;
          font-weight:800;
          letter-spacing:2px;
        }

        ::-webkit-scrollbar {
          width:6px;
          height:6px;
        }

        ::-webkit-scrollbar-track {
          background:#0d1117;
        }

        ::-webkit-scrollbar-thumb {
          background:#30363d;
          border-radius:3px;
        }
      "))
    ),
    
    tabItems(
      
      tabItem(
        tabName = "overview",
        
        fluidRow(
          valueBoxOutput("vb_batsmen", width = 3),
          valueBoxOutput("vb_bowlers", width = 3),
          valueBoxOutput("vb_matches", width = 3),
          valueBoxOutput("vb_countries", width = 3)
        ),
        
        fluidRow(
          box(
            title = "🌍 Runs by Country (ODI)",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput("plot_country_runs", height = 320)
          ),
          
          box(
            title = "🎳 Wickets by Country (ODI)",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput("plot_country_wickets", height = 320)
          )
        ),
        
        fluidRow(
          box(
            title = "📊 Format Distribution in Match History",
            width = 4,
            solidHeader = TRUE,
            plotlyOutput("plot_format_pie", height = 260)
          ),
          
          box(
            title = "📈 Matches Per Year",
            width = 8,
            solidHeader = TRUE,
            plotlyOutput("plot_matches_year", height = 260)
          )
        )
      ),
      
      tabItem(
        tabName = "batsmen",
        
        fluidRow(
          column(
            3,
            
            box(
              title = "🔍 Filters",
              width = NULL,
              solidHeader = TRUE,
              
              selectInput(
                "bat_format",
                "Format",
                choices = c("ODI", "T20", "Test")
              ),
              
              pickerInput(
                "bat_country",
                "Country",
                choices = c(
                  "All",
                  "India",
                  "Australia",
                  "England",
                  "Pakistan",
                  "New Zealand",
                  "South Africa",
                  "Sri Lanka",
                  "Bangladesh"
                ),
                selected = "All",
                multiple = FALSE,
                options = list(`live-search` = TRUE)
              ),
              
              selectInput(
                "bat_role",
                "Role",
                choices = c(
                  "All",
                  "Batsman",
                  "WK-Batsman",
                  "All-Rounder"
                )
              ),
              
              selectInput(
                "bat_hand",
                "Batting Hand",
                choices = c(
                  "All",
                  "Right",
                  "Left"
                )
              ),
              
              sliderInput(
                "bat_age",
                "Age Range",
                min = 20,
                max = 45,
                value = c(20, 45)
              ),
              
              selectInput(
                "bat_sort",
                "Sort By",
                choices = c(
                  "Average",
                  "Strike Rate",
                  "Runs",
                  "Hundreds",
                  "Fifties"
                )
              ),
              
              switchInput(
                "bat_top10",
                "Top 10 Only",
                value = FALSE,
                onLabel = "YES",
                offLabel = "NO",
                onStatus = "warning",
                offStatus = "default"
              )
            )
          ),
          
          column(
            9,
            
            fluidRow(
              box(
                title = "📊 Average vs Strike Rate",
                width = 12,
                solidHeader = TRUE,
                plotlyOutput("plot_bat_bubble", height = 340)
              )
            ),
            
            fluidRow(
              box(
                title = "📋 Batsmen Data Table",
                width = 12,
                solidHeader = TRUE,
                DTOutput("table_batsmen")
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "bowlers",
        
        fluidRow(
          column(
            3,
            
            box(
              title = "🔍 Filters",
              width = NULL,
              solidHeader = TRUE,
              
              selectInput(
                "bowl_format",
                "Format",
                choices = c("ODI", "T20", "Test")
              ),
              
              pickerInput(
                "bowl_country",
                "Country",
                choices = c(
                  "All",
                  "India",
                  "Australia",
                  "England",
                  "Pakistan",
                  "New Zealand",
                  "South Africa",
                  "Sri Lanka",
                  "Bangladesh",
                  "West Indies"
                ),
                selected = "All",
                options = list(`live-search` = TRUE)
              ),
              
              selectInput(
                "bowl_style",
                "Bowling Style",
                choices = c(
                  "All",
                  "RF",
                  "RFM",
                  "LF",
                  "LFM",
                  "OB",
                  "SLA",
                  "LBG",
                  "LSC"
                )
              ),
              
              sliderInput(
                "bowl_age",
                "Age Range",
                min = 18,
                max = 45,
                value = c(18, 45)
              ),
              
              selectInput(
                "bowl_sort",
                "Sort By",
                choices = c(
                  "Wickets",
                  "Economy",
                  "Average",
                  "Strike Rate"
                )
              )
            )
          ),
          
          column(
            9,
            
            fluidRow(
              box(
                title = "🎯 Wickets vs Economy Rate",
                width = 12,
                solidHeader = TRUE,
                plotlyOutput("plot_bowl_bubble", height = 340)
              )
            ),
            
            fluidRow(
              box(
                title = "📋 Bowlers Data Table",
                width = 12,
                solidHeader = TRUE,
                DTOutput("table_bowlers")
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "compare",
        
        fluidRow(
          box(
            title = "⚔️ Player Comparison Setup",
            width = 12,
            solidHeader = TRUE,
            
            fluidRow(
              
              column(
                4,
                
                selectInput(
                  "cmp_type",
                  "Compare Type",
                  choices = c(
                    "Batsmen vs Batsmen",
                    "Bowler vs Bowler",
                    "All Stats"
                  )
                ),
                
                selectInput(
                  "cmp_format",
                  "Format",
                  choices = c("ODI", "T20", "Test")
                )
              ),
              
              column(
                4,
                
                uiOutput("ui_player1"),
                
                tags$div(
                  style = "color:#FFD700;font-weight:bold;text-align:center;",
                  "VS"
                )
              ),
              
              column(
                4,
                
                uiOutput("ui_player2")
              )
            )
          )
        ),
        
        fluidRow(
          
          box(
            title = "📊 Side-by-Side Radar Chart",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput("plot_radar", height = 380)
          ),
          
          box(
            title = "📈 Metric Comparison Bar",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput("plot_compare_bar", height = 380)
          )
        ),
        
        fluidRow(
          
          box(
            title = "📋 Full Stats Comparison",
            width = 12,
            solidHeader = TRUE,
            tableOutput("table_compare")
          )
        )
      ),
      
      tabItem(
        tabName = "predict",
        
        fluidRow(
          
          box(
            title = "🔮 Match Setup",
            width = 4,
            solidHeader = TRUE,
            
            selectInput(
              "pred_team1",
              "🏏 Team 1",
              choices = c(
                "India",
                "Australia",
                "England",
                "Pakistan",
                "New Zealand",
                "South Africa",
                "Sri Lanka",
                "Bangladesh",
                "West Indies",
                "Afghanistan"
              )
            ),
            
            selectInput(
              "pred_team2",
              "🏏 Team 2",
              choices = c(
                "Australia",
                "India",
                "England",
                "Pakistan",
                "New Zealand",
                "South Africa",
                "Sri Lanka",
                "Bangladesh",
                "West Indies",
                "Afghanistan"
              )
            ),
            
            selectInput(
              "pred_format",
              "Format",
              choices = c("ODI", "T20I", "Test")
            ),
            
            selectInput(
              "pred_venue",
              "Venue",
              choices = c(
                "Wankhede",
                "MCG",
                "Lord's",
                "Eden Gardens",
                "Oval",
                "SCG",
                "Newlands",
                "Gaddafi",
                "Headingley",
                "SuperSport Park"
              )
            ),
            
            selectInput(
              "pred_pitch",
              "Pitch Type",
              choices = c(
                "Flat",
                "Green",
                "Dusty",
                "Bouncy",
                "Spin-friendly"
              )
            ),
            
            selectInput(
              "pred_weather",
              "Weather",
              choices = c(
                "Clear",
                "Overcast",
                "Humid",
                "Windy"
              )
            ),
            
            selectInput(
              "pred_toss",
              "Toss Winner",
              choices = c(
                "Team 1",
                "Team 2"
              )
            ),
            
            selectInput(
              "pred_toss_dec",
              "Toss Decision",
              choices = c(
                "bat",
                "field"
              )
            ),
            
            actionButton(
              "btn_predict",
              "🔮 PREDICT RESULT",
              class = "btn-predict",
              width = "100%"
            )
          ),
          
          column(
            8,
            
            uiOutput("ui_prediction_result")
          )
        )
      ),
      
      tabItem(
        tabName = "country",
        
        fluidRow(
          
          box(
            title = "🌍 Country Performance Matrix",
            width = 12,
            solidHeader = TRUE,
            
            fluidRow(
              
              column(
                3,
                
                selectInput(
                  "ctry_format",
                  "Format",
                  choices = c("ODI", "T20", "Test")
                )
              ),
              
              column(
                3,
                
                selectInput(
                  "ctry_metric",
                  "Batting Metric",
                  choices = c(
                    "Average",
                    "SR",
                    "Runs",
                    "Hundreds"
                  )
                )
              ),
              
              column(
                3,
                
                selectInput(
                  "ctry_bowl_metric",
                  "Bowling Metric",
                  choices = c(
                    "Wickets",
                    "Economy",
                    "Average"
                  )
                )
              )
            ),
            
            plotlyOutput(
              "plot_country_matrix",
              height = 400
            )
          )
        ),
        
        fluidRow(
          
          box(
            title = "🏏 Top Batsman per Country",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput(
              "plot_country_best_bat",
              height = 360
            )
          ),
          
          box(
            title = "🎳 Top Bowler per Country",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput(
              "plot_country_best_bowl",
              height = 360
            )
          )
        )
      ),
      
      tabItem(
        tabName = "trends",
        
        fluidRow(
          
          box(
            title = "📈 Win Rate by Year",
            width = 8,
            solidHeader = TRUE,
            plotlyOutput(
              "plot_win_trend",
              height = 320
            )
          ),
          
          box(
            title = "🏏 Toss Impact Analysis",
            width = 4,
            solidHeader = TRUE,
            plotlyOutput(
              "plot_toss_impact",
              height = 320
            )
          )
        ),
        
        fluidRow(
          
          box(
            title = "🔥 Score Distribution by Format",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput(
              "plot_score_dist",
              height = 320
            )
          ),
          
          box(
            title = "🏟️ Venue Win Rates",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput(
              "plot_venue_wins",
              height = 320
            )
          )
        )
      ),
      
      tabItem(
        tabName = "top",
        
        fluidRow(
          
          column(
            3,
            
            selectInput(
              "top_format",
              "Format",
              choices = c("ODI", "T20", "Test")
            )
          ),
          
          column(
            3,
            
            selectInput(
              "top_n",
              "Show Top N",
              choices = c(5, 10, 15, 20),
              selected = 10
            )
          )
        ),
        
        fluidRow(
          
          box(
            title = "🏏 Top Batsmen (Performance Index)",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput(
              "plot_top_bat",
              height = 400
            )
          ),
          
          box(
            title = "🎳 Top Bowlers (Wickets/Economy)",
            width = 6,
            solidHeader = TRUE,
            plotlyOutput(
              "plot_top_bowl",
              height = 400
            )
          )
        ),
        
        fluidRow(
          
          box(
            title = "🏆 Hall of Fame — Combined Ranking",
            width = 12,
            solidHeader = TRUE,
            DTOutput("table_top_combined")
          )
        )
      ),
      
      tabItem(
        tabName = "history",
        
        fluidRow(
          
          column(
            3,
            
            selectInput(
              "hist_format",
              "Format",
              choices = c(
                "All",
                "ODI",
                "T20I",
                "Test"
              )
            )
          ),
          
          column(
            3,
            
            selectInput(
              "hist_team",
              "Team",
              choices = c(
                "All",
                "India",
                "Australia",
                "England",
                "Pakistan",
                "New Zealand",
                "South Africa",
                "Sri Lanka",
                "Bangladesh"
              )
            )
          ),
          
          column(
            3,
            
            sliderInput(
              "hist_year",
              "Year Range",
              min = 2015,
              max = 2024,
              value = c(2015, 2024),
              sep = ""
            )
          )
        ),
        
        fluidRow(
          
          box(
            title = "📋 Match History",
            width = 12,
            solidHeader = TRUE,
            DTOutput("table_match_history")
          )
        )
      )
    )
  )
)