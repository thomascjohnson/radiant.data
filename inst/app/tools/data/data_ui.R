#######################################
# Shiny interface for data tabs
#######################################

## show error message from filter dialog
output$ui_filter_error <- renderUI({
  if (is_empty(r_data$filter_error)) return()
  helpText(r_data$filter_error)
})

## data ui and tabs
output$ui_data <- renderUI({
  tagList(
    includeCSS(file.path(getOption("radiant.path.data"),"app/www/style.css")),
    sidebarLayout(
      sidebarPanel(
        wellPanel(
          uiOutput("ui_datasets"),
          conditionalPanel("input.tabs_data != 'Manage'",
            checkboxInput("show_filter", "Filter data", value = state_init("show_filter",FALSE)),
            conditionalPanel("input.show_filter == true",
              returnTextAreaInput("data_filter", label = "",
                value = state_init("data_filter"),
                placeholder = "Provide a filter (e.g., price >  5000) and press return"
              ),
              uiOutput("ui_filter_error")))
        ),
        conditionalPanel("input.tabs_data == 'Manage'", uiOutput("ui_Manage")),
        conditionalPanel("input.tabs_data == 'View'", uiOutput("ui_View")),
        conditionalPanel("input.tabs_data == 'Visualize'", uiOutput("ui_Visualize")),
        conditionalPanel("input.tabs_data == 'Pivot'",uiOutput("ui_Pivotr")),
        conditionalPanel("input.tabs_data == 'Explore'", uiOutput("ui_Explore")),
        conditionalPanel("input.tabs_data == 'Transform'", uiOutput("ui_Transform")),
        conditionalPanel("input.tabs_data == 'Combine'", uiOutput("ui_Combine"))),
      mainPanel(
        tabsetPanel(id = "tabs_data",
          tabPanel("Manage",
            conditionalPanel("input.dman_preview == 'preview'", h2("Data preview"), htmlOutput("htmlDataExample")),
            conditionalPanel("input.dman_preview == 'str'", h2("Data structure"), verbatimTextOutput("strData")),
            conditionalPanel("input.dman_preview == 'summary'", h2("Data summary"), verbatimTextOutput("summaryData")),
            conditionalPanel("input.man_add_descr == false", uiOutput("dataDescriptionHTML")),
            conditionalPanel("input.man_add_descr == true", uiOutput("dataDescriptionMD"))
          ),
          tabPanel("View",
            downloadLink("dl_view_tab", "", class = "fa fa-download alignright"),
            DT::dataTableOutput("dataviewer")
          ),
          tabPanel("Visualize",
            conditionalPanel("input.viz_pause == false",
              plot_downloader(".visualize", width = viz_plot_width, height = viz_plot_height, pre = "")
            ),
            plotOutput("visualize", width = "100%", height = "100%")
          ),
          tabPanel("Pivot",
            conditionalPanel("input.pvt_tab == true",
              conditionalPanel("input.pvt_pause == false",
                downloadLink("dl_pivot_tab", "", class = "fa fa-download alignright")
              ),
              DT::dataTableOutput("pivotr")
            ),
            conditionalPanel("input.pvt_chi2 == true", htmlOutput("pivotr_chi2")),
            conditionalPanel("input.pvt_plot == true", br(), br(),
              conditionalPanel("input.pvt_pause == false",
                plot_downloader("pivot", width = pvt_plot_width, height = pvt_plot_height)
              ),
              plotOutput("plot_pivot", width = "100%", height = "100%")
            )
          ),
          tabPanel("Explore",
            conditionalPanel("input.expl_pause == false",
              downloadLink("dl_explore_tab", "", class = "fa fa-download alignright")
            ),
            DT::dataTableOutput("explore")),
          tabPanel("Transform",
            htmlOutput("transform_data"),
            verbatimTextOutput("transform_summary"),
            uiOutput("ui_tr_log")
          ),
          tabPanel("Combine",
            htmlOutput("cmb_data1"),
            htmlOutput("cmb_data2"),
            htmlOutput("cmb_possible"),
            htmlOutput("cmb_data")
          )
        )
      )
    )
  )
})
