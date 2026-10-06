library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(ggplot2)
library(plotly)
library(dplyr)
library(DT)
library(randomForest)
library(caret)
library(reshape2)
library(scales)
library(RColorBrewer)

if (!exists("cricket_data", inherits = TRUE)) {
  source("data.R")
  cricket_data <- generate_cricket_data()
}

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0 || all(is.na(x))) {
    y
  } else {
    x
  }
}

server <- function(input, output, session) {
  
  GOLD <- "#FFD700"
  ORANGE <- "#ff8c00"
  TEAL <- "#00b4d8"
  GREEN <- "#00c864"
  RED <- "#ff4040"
  BG <- "#0d1117"
  CARD <- "#161b22"
  BORDER <- "#30363d"
  
  dark_theme <- function() {
    list(
      paper_bgcolor = BG,
      plot_bgcolor = BG,
      font = list(color = "#c9d1d9"),
      xaxis = list(
        gridcolor = BORDER,
        linecolor = BORDER,
        zerolinecolor = BORDER
      ),
      yaxis = list(
        gridcolor = BORDER,
        linecolor = BORDER,
        zerolinecolor = BORDER
      ),
      margin = list(l = 50, r = 20, t = 40, b = 50)
    )
  }
  
  get_cols <- function(fmt) {
    list(
      avg = paste0("Average_", fmt),
      sr = paste0("SR_", fmt),
      runs = paste0("Runs_", fmt),
      mat = paste0("Matches_", fmt),
      wkt = paste0("Wickets_", fmt),
      eco = paste0("Economy_", fmt)
    )
  }
  
  output$vb_batsmen <- renderValueBox({
    valueBox(
      nrow(cricket_data$batsmen),
      "Total Batsmen",
      icon = icon("user"),
      color = "yellow"
    )
  })
  
  output$vb_bowlers <- renderValueBox({
    valueBox(
      nrow(cricket_data$bowlers),
      "Total Bowlers",
      icon = icon("circle"),
      color = "orange"
    )
  })
  
  output$vb_matches <- renderValueBox({
    valueBox(
      nrow(cricket_data$match_history),
      "Matches Logged",
      icon = icon("trophy"),
      color = "aqua"
    )
  })
  
  output$vb_countries <- renderValueBox({
    n <- length(unique(cricket_data$batsmen$Country))
    valueBox(
      n,
      "Countries",
      icon = icon("globe"),
      color = "green"
    )
  })
  
  output$plot_country_runs <- renderPlotly({
    df <- cricket_data$batsmen %>%
      group_by(Country) %>%
      summarise(
        Total_Runs = sum(Runs_ODI, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(desc(Total_Runs))
    
    plot_ly(
      df,
      x = ~reorder(Country, Total_Runs),
      y = ~Total_Runs,
      type = "bar",
      marker = list(
        color = GOLD,
        line = list(color = ORANGE, width = 1.5)
      )
    ) %>%
      layout(
        xaxis = list(title = "Country"),
        yaxis = list(title = "Total ODI Runs"),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        margin = list(b = 80)
      )
  })
  
  output$plot_country_wickets <- renderPlotly({
    df <- cricket_data$bowlers %>%
      group_by(Country) %>%
      summarise(
        Total_Wkts = sum(Wickets_ODI, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(desc(Total_Wkts))
    
    plot_ly(
      df,
      x = ~reorder(Country, Total_Wkts),
      y = ~Total_Wkts,
      type = "bar",
      marker = list(
        color = TEAL,
        line = list(color = "#0077a3", width = 1.5)
      )
    ) %>%
      layout(
        xaxis = list(title = "Country"),
        yaxis = list(title = "Total ODI Wickets"),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        margin = list(b = 80)
      )
  })
  
  output$plot_format_pie <- renderPlotly({
    df <- cricket_data$match_history %>%
      dplyr::count(Format)
    
    plot_ly(
      df,
      labels = ~Format,
      values = ~n,
      type = "pie",
      marker = list(colors = c(GOLD, TEAL, ORANGE)),
      textinfo = "label+percent"
    ) %>%
      layout(
        paper_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        showlegend = TRUE,
        margin = list(t = 10, b = 10)
      )
  })
  
  output$plot_matches_year <- renderPlotly({
    df <- cricket_data$match_history %>%
      dplyr::count(Year)
    
    plot_ly(
      df,
      x = ~Year,
      y = ~n,
      type = "scatter",
      mode = "lines+markers",
      line = list(color = GOLD, width = 3),
      marker = list(color = GOLD, size = 8)
    ) %>%
      layout(
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        xaxis = list(title = "Year", gridcolor = BORDER),
        yaxis = list(title = "Matches", gridcolor = BORDER)
      )
  })
  
  bat_filtered <- reactive({
    fmt <- input$bat_format
    cols <- get_cols(fmt)
    
    df <- cricket_data$batsmen %>%
      filter(
        Age >= input$bat_age[1],
        Age <= input$bat_age[2]
      )
    
    if (input$bat_country != "All") {
      df <- df %>%
        filter(Country == input$bat_country)
    }
    
    if (input$bat_role != "All") {
      df <- df %>%
        filter(Role == input$bat_role)
    }
    
    if (input$bat_hand != "All") {
      df <- df %>%
        filter(Batting_Style == input$bat_hand)
    }
    
    df <- df %>%
      mutate(
        Avg = .data[[cols$avg]],
        SR = .data[[cols$sr]],
        Runs = .data[[cols$runs]],
        Mat = .data[[cols$mat]]
      ) %>%
      filter(!is.na(Avg), Avg > 0)
    
    sort_col <- switch(
      input$bat_sort,
      "Average" = "Avg",
      "Strike Rate" = "SR",
      "Runs" = "Runs",
      "Hundreds" = "Hundreds_ODI",
      "Fifties" = "Fifties_ODI",
      "Avg"
    )
    
    df <- df %>%
      arrange(desc(.data[[sort_col]]))
    
    if (isTRUE(input$bat_top10)) {
      df <- head(df, 10)
    }
    
    df
  })
  
  output$plot_bat_bubble <- renderPlotly({
    df <- bat_filtered()
    
    req(nrow(df) > 0)
    
    plot_ly(
      df,
      x = ~SR,
      y = ~Avg,
      size = ~Runs,
      color = ~Country,
      text = ~paste0(
        "<b>", Player, "</b><br>",
        "Country: ", Country,
        "<br>Avg: ", round(Avg, 1),
        "<br>SR: ", round(SR, 1),
        "<br>Runs: ", Runs,
        "<br>Age: ", Age
      ),
      hoverinfo = "text",
      type = "scatter",
      mode = "markers",
      marker = list(
        sizemode = "area",
        sizeref = 2 * max(df$Runs, na.rm = TRUE) / (40^2),
        opacity = 0.8
      )
    ) %>%
      layout(
        xaxis = list(
          title = "Strike Rate",
          gridcolor = BORDER
        ),
        yaxis = list(
          title = "Average",
          gridcolor = BORDER
        ),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        legend = list(
          orientation = "h",
          y = -0.2
        )
      )
  })
  
  output$table_batsmen <- renderDT({
    df <- bat_filtered() %>%
      select(
        Player,
        Country,
        Age,
        Role,
        Matches = Mat,
        Runs,
        Average = Avg,
        `Strike Rate` = SR,
        Hundreds_ODI,
        Fifties_ODI
      )
    
    datatable(
      df,
      options = list(
        pageLength = 10,
        scrollX = TRUE
      ),
      rownames = FALSE,
      class = "table-dark table-hover compact"
    ) %>%
      formatRound(
        c("Average", "Strike Rate"),
        2
      ) %>%
      formatStyle(
        "Average",
        color = GOLD,
        fontWeight = "bold"
      ) %>%
      formatStyle(
        "Strike Rate",
        color = TEAL
      )
  })
  
  bowl_filtered <- reactive({
    fmt <- input$bowl_format
    cols <- get_cols(fmt)
    
    df <- cricket_data$bowlers %>%
      filter(
        Age >= input$bowl_age[1],
        Age <= input$bowl_age[2]
      )
    
    if (input$bowl_country != "All") {
      df <- df %>%
        filter(Country == input$bowl_country)
    }
    
    if (input$bowl_style != "All") {
      df <- df %>%
        filter(Bowling_Style == input$bowl_style)
    }
    
    df <- df %>%
      mutate(
        Wkts = .data[[cols$wkt]],
        Eco = .data[[cols$eco]],
        Avg_Bowl = Average_Bowl_ODI,
        SR_Bowl = SR_Bowl_ODI
      )
    
    sort_col <- switch(
      input$bowl_sort,
      "Wickets" = "Wkts",
      "Economy" = "Eco",
      "Average" = "Avg_Bowl",
      "Strike Rate" = "SR_Bowl",
      "Wkts"
    )
    
    if (sort_col == "Eco") {
      df <- df %>%
        arrange(.data[[sort_col]])
    } else {
      df <- df %>%
        arrange(desc(.data[[sort_col]]))
    }
    
    df
  })
  
  output$plot_bowl_bubble <- renderPlotly({
    df <- cricket_data$bowlers
    fmt <- input$bowl_format
    cols <- get_cols(fmt)
    
    df <- df %>%
      mutate(
        Wkts = .data[[cols$wkt]],
        Eco = .data[[cols$eco]]
      )
    
    if (input$bowl_country != "All") {
      df <- df %>%
        filter(Country == input$bowl_country)
    }
    
    if (input$bowl_style != "All") {
      df <- df %>%
        filter(Bowling_Style == input$bowl_style)
    }
    
    df <- df %>%
      filter(!is.na(Eco), Wkts > 0)
    
    req(nrow(df) > 0)
    
    plot_ly(
      df,
      x = ~Eco,
      y = ~Wkts,
      size = ~Wkts,
      color = ~Country,
      text = ~paste0(
        "<b>", Player, "</b><br>",
        "Country: ", Country,
        "<br>Wickets: ", Wkts,
        "<br>Economy: ", round(Eco, 2),
        "<br>Style: ", Bowling_Style
      ),
      hoverinfo = "text",
      type = "scatter",
      mode = "markers",
      marker = list(
        sizemode = "area",
        sizeref = 2 * max(df$Wkts, na.rm = TRUE) / (40^2),
        opacity = 0.8
      )
    ) %>%
      layout(
        xaxis = list(
          title = "Economy Rate",
          gridcolor = BORDER
        ),
        yaxis = list(
          title = "Wickets",
          gridcolor = BORDER
        ),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        legend = list(
          orientation = "h",
          y = -0.2
        )
      )
  })
  
  output$table_bowlers <- renderDT({
    df <- bowl_filtered() %>%
      select(
        Player,
        Country,
        Age,
        Role,
        Bowling_Style,
        Wickets_ODI,
        Economy_ODI,
        Average_Bowl_ODI,
        SR_Bowl_ODI,
        Best_Bowling
      )
    
    datatable(
      df,
      options = list(
        pageLength = 10,
        scrollX = TRUE
      ),
      rownames = FALSE,
      class = "table-dark table-hover compact"
    ) %>%
      formatRound(
        c(
          "Economy_ODI",
          "Average_Bowl_ODI",
          "SR_Bowl_ODI"
        ),
        2
      ) %>%
      formatStyle(
        "Wickets_ODI",
        color = GOLD,
        fontWeight = "bold"
      ) %>%
      formatStyle(
        "Economy_ODI",
        color = TEAL
      )
  })
  
  get_player_pool <- reactive({
    if (grepl("Bat", input$cmp_type)) {
      cricket_data$batsmen$Player
    } else if (grepl("Bowl", input$cmp_type)) {
      cricket_data$bowlers$Player
    } else {
      c(
        cricket_data$batsmen$Player,
        cricket_data$bowlers$Player
      )
    }
  })
  
  output$ui_player1 <- renderUI({
    pool <- get_player_pool()
    
    req(length(pool) >= 1)
    
    selectInput(
      "cmp_p1",
      "Player 1",
      choices = pool,
      selected = pool[1]
    )
  })
  
  output$ui_player2 <- renderUI({
    pool <- get_player_pool()
    
    req(length(pool) >= 2)
    
    selectInput(
      "cmp_p2",
      "Player 2",
      choices = pool,
      selected = pool[2]
    )
  })
  
  get_player_stats <- function(name, fmt) {
    
    bat <- cricket_data$batsmen %>%
      filter(Player == name)
    
    bowl <- cricket_data$bowlers %>%
      filter(Player == name)
    
    if (nrow(bat) > 0) {
      
      row <- bat[1, ]
      
      avg_col <- paste0("Average_", fmt)
      sr_col <- paste0("SR_", fmt)
      run_col <- paste0("Runs_", fmt)
      mat_col <- paste0("Matches_", fmt)
      
      list(
        type = "Batsman",
        Player = name,
        Country = row$Country,
        Age = row$Age,
        Role = row$Role,
        Average = row[[avg_col]],
        SR = row[[sr_col]],
        Runs = row[[run_col]],
        Matches = row[[mat_col]],
        Hundreds = row$Hundreds_ODI,
        Fifties = row$Fifties_ODI
      )
      
    } else if (nrow(bowl) > 0) {
      
      row <- bowl[1, ]
      
      wkt_col <- paste0("Wickets_", fmt)
      eco_col <- paste0("Economy_", fmt)
      
      list(
        type = "Bowler",
        Player = name,
        Country = row$Country,
        Age = row$Age,
        Role = row$Role,
        Wickets = row[[wkt_col]],
        Economy = row[[eco_col]],
        Average = row$Average_Bowl_ODI,
        SR = row$SR_Bowl_ODI,
        Best = row$Best_Bowling
      )
      
    } else {
      NULL
    }
  }
  
  output$plot_radar <- renderPlotly({
    
    req(input$cmp_p1, input$cmp_p2)
    
    fmt <- input$cmp_format
    
    p1 <- get_player_stats(
      input$cmp_p1,
      fmt
    )
    
    p2 <- get_player_stats(
      input$cmp_p2,
      fmt
    )
    
    req(!is.null(p1), !is.null(p2))
    
    metrics <- c(
      "Average",
      "SR",
      "Hundreds",
      "Fifties",
      "Matches"
    )
    
    get_vals <- function(p) {
      
      if (p$type == "Batsman") {
        
        c(
          min(p$Average / 60, 1) * 100,
          min(p$SR / 160, 1) * 100,
          min((p$Hundreds %||% 0) / 30, 1) * 100,
          min((p$Fifties %||% 0) / 60, 1) * 100,
          min(p$Matches / 200, 1) * 100
        )
        
      } else {
        
        c(
          min((p$Wickets %||% 0) / 300, 1) * 100,
          min(max(10 - p$Economy, 0) / 6, 1) * 100,
          min((p$Average %||% 50) / 50, 1) * 100,
          min((p$SR %||% 50) / 50, 1) * 100,
          60
        )
      }
    }
    
    v1 <- get_vals(p1)
    v2 <- get_vals(p2)
    
    lbls <- c(metrics, metrics[1])
    
    v1c <- c(v1, v1[1])
    v2c <- c(v2, v2[1])
    
    plot_ly(
      type = "scatterpolar",
      mode = "lines+markers",
      fill = "toself"
    ) %>%
      add_trace(
        r = v1c,
        theta = lbls,
        name = input$cmp_p1,
        line = list(color = GOLD),
        marker = list(color = GOLD)
      ) %>%
      add_trace(
        r = v2c,
        theta = lbls,
        name = input$cmp_p2,
        line = list(color = TEAL),
        marker = list(color = TEAL)
      ) %>%
      layout(
        polar = list(
          radialaxis = list(
            visible = TRUE,
            range = c(0, 100),
            gridcolor = BORDER,
            linecolor = BORDER
          ),
          angularaxis = list(
            linecolor = BORDER
          ),
          bgcolor = BG
        ),
        paper_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        showlegend = TRUE
      )
  })
  
  output$plot_compare_bar <- renderPlotly({
    
    req(input$cmp_p1, input$cmp_p2)
    
    fmt <- input$cmp_format
    
    p1 <- get_player_stats(
      input$cmp_p1,
      fmt
    )
    
    p2 <- get_player_stats(
      input$cmp_p2,
      fmt
    )
    
    req(!is.null(p1), !is.null(p2))
    
    if (p1$type == "Batsman") {
      
      cats <- c(
        "Average",
        "Strike Rate",
        "Hundreds",
        "Fifties"
      )
      
      v1 <- c(
        p1$Average,
        p1$SR,
        p1$Hundreds %||% 0,
        p1$Fifties %||% 0
      )
      
      v2 <- c(
        p2$Average,
        p2$SR,
        p2$Hundreds %||% 0,
        p2$Fifties %||% 0
      )
      
    } else {
      
      cats <- c(
        "Wickets",
        "Economy",
        "Bowl Avg",
        "Bowl SR"
      )
      
      v1 <- c(
        p1$Wickets %||% 0,
        p1$Economy %||% 0,
        p1$Average %||% 0,
        p1$SR %||% 0
      )
      
      v2 <- c(
        p2$Wickets %||% 0,
        p2$Economy %||% 0,
        p2$Average %||% 0,
        p2$SR %||% 0
      )
    }
    
    plot_ly() %>%
      add_bars(
        x = cats,
        y = v1,
        name = input$cmp_p1,
        marker = list(color = GOLD)
      ) %>%
      add_bars(
        x = cats,
        y = v2,
        name = input$cmp_p2,
        marker = list(color = TEAL)
      ) %>%
      layout(
        barmode = "group",
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        xaxis = list(gridcolor = BORDER),
        yaxis = list(gridcolor = BORDER)
      )
  })
  
  output$table_compare <- renderTable({
    
    req(input$cmp_p1, input$cmp_p2)
    
    fmt <- input$cmp_format
    
    p1 <- get_player_stats(
      input$cmp_p1,
      fmt
    )
    
    p2 <- get_player_stats(
      input$cmp_p2,
      fmt
    )
    
    req(!is.null(p1), !is.null(p2))
    
    p1n <- Filter(is.atomic, p1)
    p2n <- Filter(is.atomic, p2)
    
    nms <- intersect(
      names(p1n),
      names(p2n)
    )
    
    df <- data.frame(
      Metric = nms,
      P1 = sapply(p1n[nms], function(x) {
        if (length(x) == 0) "" else as.character(x[1])
      }),
      P2 = sapply(p2n[nms], function(x) {
        if (length(x) == 0) "" else as.character(x[1])
      }),
      stringsAsFactors = FALSE
    )
    
    colnames(df)[2:3] <- c(
      input$cmp_p1,
      input$cmp_p2
    )
    
    df
    
  }, striped = TRUE, bordered = TRUE, hover = TRUE)
  
  output$plot_country_matrix <- renderPlotly({
    
    fmt <- input$ctry_format
    cols <- get_cols(fmt)
    
    bat_grp <- cricket_data$batsmen %>%
      group_by(Country) %>%
      summarise(
        Avg_Bat = mean(
          .data[[cols$avg]],
          na.rm = TRUE
        ),
        Avg_SR = mean(
          .data[[cols$sr]],
          na.rm = TRUE
        ),
        .groups = "drop"
      )
    
    bowl_grp <- cricket_data$bowlers %>%
      group_by(Country) %>%
      summarise(
        Avg_Wkts = mean(
          .data[[cols$wkt]],
          na.rm = TRUE
        ),
        Avg_Eco = mean(
          .data[[cols$eco]],
          na.rm = TRUE
        ),
        .groups = "drop"
      )
    
    df <- inner_join(
      bat_grp,
      bowl_grp,
      by = "Country"
    )
    
    plot_ly(
      df,
      x = ~Avg_Bat,
      y = ~Avg_Eco,
      text = ~Country,
      color = ~Country,
      size = ~Avg_Wkts,
      type = "scatter",
      mode = "markers+text",
      textposition = "top center"
    ) %>%
      layout(
        xaxis = list(
          title = "Batting Average",
          gridcolor = BORDER
        ),
        yaxis = list(
          title = "Bowling Economy",
          gridcolor = BORDER
        ),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9")
      )
  })
  
  output$plot_country_best_bat <- renderPlotly({
    
    fmt <- input$ctry_format
    avg_col <- paste0(
      "Average_",
      fmt
    )
    
    df <- cricket_data$batsmen %>%
      filter(!is.na(.data[[avg_col]])) %>%
      group_by(Country) %>%
      slice_max(
        order_by = .data[[avg_col]],
        n = 1
      ) %>%
      ungroup()
    
    plot_ly(
      df,
      x = ~.data[[avg_col]],
      y = ~reorder(
        Player,
        .data[[avg_col]]
      ),
      type = "bar",
      orientation = "h",
      color = ~Country,
      text = ~paste(
        Player,
        "-",
        Country
      ),
      hoverinfo = "text"
    ) %>%
      layout(
        xaxis = list(title = "Average"),
        yaxis = list(title = ""),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        showlegend = FALSE
      )
  })
  
  output$plot_country_best_bowl <- renderPlotly({
    
    fmt <- input$ctry_format
    
    wkt_col <- paste0(
      "Wickets_",
      fmt
    )
    
    df <- cricket_data$bowlers %>%
      filter(
        !is.na(.data[[wkt_col]]),
        .data[[wkt_col]] > 0
      ) %>%
      group_by(Country) %>%
      slice_max(
        order_by = .data[[wkt_col]],
        n = 1
      ) %>%
      ungroup()
    
    plot_ly(
      df,
      x = ~.data[[wkt_col]],
      y = ~reorder(
        Player,
        .data[[wkt_col]]
      ),
      type = "bar",
      orientation = "h",
      color = ~Country,
      text = ~paste(
        Player,
        "-",
        Country
      ),
      hoverinfo = "text"
    ) %>%
      layout(
        xaxis = list(title = "Wickets"),
        yaxis = list(title = ""),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        showlegend = FALSE
      )
  })
  
  output$plot_win_trend <- renderPlotly({
    
    df <- cricket_data$match_history %>%
      filter(Winner_Team != "Draw") %>%
      mutate(
        Team1_Win = Winner_Team == "Team1"
      ) %>%
      group_by(Year) %>%
      summarise(
        Win_Rate = mean(Team1_Win) * 100,
        .groups = "drop"
      )
    
    plot_ly(
      df,
      x = ~Year,
      y = ~Win_Rate,
      type = "scatter",
      mode = "lines+markers",
      line = list(
        color = GOLD,
        width = 3
      )
    ) %>%
      layout(
        xaxis = list(title = "Year"),
        yaxis = list(
          title = "Team 1 Win Rate (%)"
        ),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9")
      )
  })
  
  output$plot_toss_impact <- renderPlotly({
    
    df <- cricket_data$match_history %>%
      filter(Winner_Team != "Draw") %>%
      mutate(
        Toss_Won_Match =
          Winner_Team == Toss_Winner
      ) %>%
      group_by(Toss_Decision) %>%
      summarise(
        Pct = mean(Toss_Won_Match) * 100,
        .groups = "drop"
      )
    
    plot_ly(
      df,
      x = ~Toss_Decision,
      y = ~Pct,
      type = "bar",
      marker = list(
        color = c(GREEN, TEAL)
      )
    ) %>%
      layout(
        xaxis = list(title = "Decision"),
        yaxis = list(title = "Win %"),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9")
      )
  })
  
  output$plot_score_dist <- renderPlotly({
    
    df <- cricket_data$match_history %>%
      select(
        Format,
        Score = Team1_Score
      )
    
    plot_ly(
      df,
      x = ~Score,
      color = ~Format,
      type = "histogram",
      opacity = 0.75
    ) %>%
      layout(
        barmode = "overlay",
        xaxis = list(title = "Score"),
        yaxis = list(title = "Count"),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9")
      )
  })
  
  output$plot_venue_wins <- renderPlotly({
    
    df <- cricket_data$match_history %>%
      filter(Winner_Team != "Draw") %>%
      mutate(
        Team1_Win =
          Winner_Team == "Team1"
      ) %>%
      group_by(Venue) %>%
      summarise(
        Win_Rate =
          mean(Team1_Win) * 100,
        .groups = "drop"
      )
    
    plot_ly(
      df,
      x = ~Win_Rate,
      y = ~reorder(Venue, Win_Rate),
      type = "bar",
      orientation = "h",
      marker = list(color = ORANGE)
    ) %>%
      layout(
        xaxis = list(
          title = "Win Rate %"
        ),
        yaxis = list(title = ""),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9")
      )
  })
  
  output$plot_top_bat <- renderPlotly({
    
    fmt <- input$top_format
    n <- as.integer(input$top_n)
    
    df <- cricket_data$batsmen
    
    if (fmt == "ODI") {
      
      df <- df %>%
        mutate(
          PI = (Average_ODI * SR_ODI) / 100
        )
      
    } else if (fmt == "T20") {
      
      df <- df %>%
        mutate(
          PI = (Average_T20 * SR_T20) / 100
        )
      
    } else {
      
      df <- df %>%
        mutate(
          PI = Average_Test * 1.5
        )
    }
    
    df <- df %>%
      filter(!is.na(PI), PI > 0) %>%
      arrange(desc(PI)) %>%
      head(n)
    
    plot_ly(
      df,
      x = ~PI,
      y = ~reorder(Player, PI),
      type = "bar",
      orientation = "h",
      color = ~Country,
      text = ~paste0(
        "<b>", Player, "</b><br>",
        "Country: ", Country,
        "<br>PI Score: ", round(PI, 1)
      ),
      hoverinfo = "text"
    ) %>%
      layout(
        xaxis = list(
          title = "Performance Index"
        ),
        yaxis = list(title = ""),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        showlegend = FALSE
      )
  })
  
  output$plot_top_bowl <- renderPlotly({
    
    fmt <- input$top_format
    n <- as.integer(input$top_n)
    
    df <- cricket_data$bowlers
    
    if (fmt == "ODI") {
      
      df <- df %>%
        mutate(
          Score =
            Wickets_ODI / Economy_ODI
        )
      
    } else if (fmt == "T20") {
      
      df <- df %>%
        mutate(
          Score =
            Wickets_T20 / Economy_T20
        )
      
    } else {
      
      df <- df %>%
        mutate(
          Score =
            Wickets_Test / 10
        )
    }
    
    df <- df %>%
      filter(
        !is.na(Score),
        Score > 0
      ) %>%
      arrange(desc(Score)) %>%
      head(n)
    
    plot_ly(
      df,
      x = ~Score,
      y = ~reorder(Player, Score),
      type = "bar",
      orientation = "h",
      color = ~Country,
      text = ~paste0(
        "<b>", Player, "</b><br>",
        "Country: ", Country,
        "<br>Bowling Score: ",
        round(Score, 1)
      ),
      hoverinfo = "text"
    ) %>%
      layout(
        xaxis = list(
          title = "Bowling Score"
        ),
        yaxis = list(title = ""),
        paper_bgcolor = BG,
        plot_bgcolor = BG,
        font = list(color = "#c9d1d9"),
        showlegend = FALSE
      )
  })
  
  output$table_top_combined <- renderDT({
    
    fmt <- input$top_format
    n <- as.integer(input$top_n)
    
    if (fmt == "ODI") {
      
      top_bat <- cricket_data$batsmen %>%
        mutate(
          PI =
            (Average_ODI * SR_ODI) / 100,
          Category = "Batsman"
        ) %>%
        filter(
          !is.na(PI),
          PI > 0
        ) %>%
        arrange(desc(PI)) %>%
        head(n) %>%
        select(
          Player,
          Country,
          Category,
          Score = PI
        )
      
      top_bowl <- cricket_data$bowlers %>%
        mutate(
          Score =
            Wickets_ODI / Economy_ODI,
          Category = "Bowler"
        ) %>%
        filter(
          !is.na(Score),
          Score > 0
        ) %>%
        arrange(desc(Score)) %>%
        head(n) %>%
        select(
          Player,
          Country,
          Category,
          Score
        )
      
    } else if (fmt == "T20") {
      
      top_bat <- cricket_data$batsmen %>%
        mutate(
          PI =
            (Average_T20 * SR_T20) / 100,
          Category = "Batsman"
        ) %>%
        filter(
          !is.na(PI),
          PI > 0
        ) %>%
        arrange(desc(PI)) %>%
        head(n) %>%
        select(
          Player,
          Country,
          Category,
          Score = PI
        )
      
      top_bowl <- cricket_data$bowlers %>%
        mutate(
          Score =
            Wickets_T20 / Economy_T20,
          Category = "Bowler"
        ) %>%
        filter(
          !is.na(Score),
          Score > 0
        ) %>%
        arrange(desc(Score)) %>%
        head(n) %>%
        select(
          Player,
          Country,
          Category,
          Score
        )
      
    } else {
      
      top_bat <- cricket_data$batsmen %>%
        mutate(
          PI =
            Average_Test * 1.5,
          Category = "Batsman"
        ) %>%
        filter(
          !is.na(PI),
          PI > 0
        ) %>%
        arrange(desc(PI)) %>%
        head(n) %>%
        select(
          Player,
          Country,
          Category,
          Score = PI
        )
      
      top_bowl <- cricket_data$bowlers %>%
        mutate(
          Score =
            Wickets_Test / 10,
          Category = "Bowler"
        ) %>%
        filter(
          !is.na(Score),
          Score > 0
        ) %>%
        arrange(desc(Score)) %>%
        head(n) %>%
        select(
          Player,
          Country,
          Category,
          Score
        )
    }
    
    combined <- bind_rows(
      top_bat,
      top_bowl
    ) %>%
      arrange(desc(Score)) %>%
      mutate(
        Rank = row_number(),
        Score = round(Score, 2)
      ) %>%
      select(
        Rank,
        Player,
        Country,
        Category,
        Score
      )
    
    datatable(
      combined,
      options = list(
        pageLength = 20,
        dom = "frtip"
      ),
      rownames = FALSE,
      class = "table-dark compact hover"
    ) %>%
      formatStyle(
        "Score",
        color = GOLD,
        fontWeight = "bold"
      )
  })
  
  output$table_match_history <- renderDT({
    
    df <- cricket_data$match_history
    
    if (input$hist_format != "All") {
      df <- df %>%
        filter(
          Format == input$hist_format
        )
    }
    
    if (input$hist_team != "All") {
      df <- df %>%
        filter(
          Team1 == input$hist_team |
            Team2 == input$hist_team
        )
    }
    
    df <- df %>%
      filter(
        Year >= input$hist_year[1],
        Year <= input$hist_year[2]
      ) %>%
      select(
        Match_ID,
        Team1,
        Team2,
        Format,
        Venue,
        Year,
        Team1_Score,
        Team2_Score,
        Toss_Winner,
        Toss_Decision,
        Winner_Team,
        Pitch_Type,
        Weather
      )
    
    datatable(
      df,
      options = list(
        pageLength = 15,
        scrollX = TRUE
      ),
      rownames = FALSE,
      filter = "top",
      class = "table-dark compact hover"
    )
  })
}