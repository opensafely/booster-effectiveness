library('tidyverse')
library('yaml')
library('here')
library('glue')

# create action functions ----

## create comment function ----
comment <- function(...){
  list_comments <- list(...)
  comments <- map(list_comments, ~paste0("## ", ., " ##"))
  comments
}


## create function to convert comment "actions" in a yaml string into proper comments
convert_comment_actions <-function(yaml.txt){
  yaml.txt %>%
    str_replace_all("\\\n(\\s*)\\'\\'\\:(\\s*)\\'", "\n\\1")  %>%
    #str_replace_all("\\\n(\\s*)\\'", "\n\\1") %>%
    str_replace_all("([^\\'])\\\n(\\s*)\\#\\#", "\\1\n\n\\2\\#\\#") %>%
    str_replace_all("\\#\\#\\'\\\n", "\n")
}
as.yaml(splice(a="c", b="'c'", comment("fff")))
convert_comment_actions(as.yaml(splice(a="c", b="'c'", comment("fff"))))


## generic action function ----
action <- function(
  name,
  run,
  arguments=NULL,
  needs=NULL,
  highly_sensitive=NULL,
  moderately_sensitive=NULL,
  ... # other arguments / options for special action types
){

  outputs <- list(
    highly_sensitive = highly_sensitive,
    moderately_sensitive = moderately_sensitive
  )
  outputs[sapply(outputs, is.null)] <- NULL

  action <- list(
    run = paste(c(run, arguments), collapse=" "),
    needs = needs,
    outputs = outputs,
    ... = ...
  )
  action[sapply(action, is.null)] <- NULL

  action_list <- list(name = action)
  names(action_list) <- name

  action_list
}


## model action function ----
action_model <- function(
  treatment, outcome
){

  splice(
    action(
      name = glue("model_seqtrialcox_{treatment}_{outcome}"),
      run = glue("r:latest analysis/model_seqtrialcox.R"),
      arguments = c(treatment, outcome),
      needs = list("data_selection", "data_process_long"),
      highly_sensitive = lst(
        rds = glue("output/models/seqtrialcox/{treatment}/{outcome}/model_*.rds")
      ),
      moderately_sensitive = lst(
        txt = glue("output/models/seqtrialcox/{treatment}/{outcome}/model_*.txt"),
        csv = glue("output/models/seqtrialcox/{treatment}/{outcome}/model_*.csv")
      )
    ),

    action(
      name = glue("report_seqtrialcox_{treatment}_{outcome}"),
      run = glue("r:latest analysis/report_seqtrialcox.R"),
      arguments = c(treatment, outcome),
      needs = list(glue("model_seqtrialcox_{treatment}_{outcome}")),
      moderately_sensitive = lst(
        csv = glue("output/models/seqtrialcox/{treatment}/{outcome}/report_*.csv"),
        svg = glue("output/models/seqtrialcox/{treatment}/{outcome}/report_*.svg"),
        png = glue("output/models/seqtrialcox/{treatment}/{outcome}/report_*.png")
      )
    )
  )
}




# specify project ----

## defaults ----
defaults_list <- lst(
  version = "3.0",
  expectations= lst(population_size=100000L)
)

## actions ----
actions_list <- splice(

  comment("# # # # # # # # # # # # # # # # # # #",
          "DO NOT EDIT project.yaml DIRECTLY",
          "This file is created by create-project.R",
          "Edit and run create-project.R to update the project.yaml",
          "# # # # # # # # # # # # # # # # # # #"
          ),


  comment("# # # # # # # # # # # # # # # # # # #", "Pre-server scripts", "# # # # # # # # # # # # # # # # # # #"),

  # do not incorporate into project for now -- just run locally

  # action(
  #   name = "checkyaml",
  #   run = "r:latest create-project.R",
  #   moderately_sensitive = lst(
  #     project = "project.yaml"
  #   )
  # ),

  # action(
  #   name = "dummydata",
  #   run = "r:latest analysis/dummydata.R",
  #   moderately_sensitive = lst(
  #     metadata = "output/design/*"
  #   )
  # ),


  comment("# # # # # # # # # # # # # # # # # # #", "Extract and tidy", "# # # # # # # # # # # # # # # # # # #"),

  action(
    name = "extract",
    run = "cohortextractor:latest generate_cohort --study-definition study_definition --output-format feather",
    needs = list(),
    highly_sensitive = lst(
      cohort = "output/input.feather"
    )
  ),

  action(
    name = "extract_report",
    run = "cohort-report:v3.0.0 output/input.feather",
    needs = list("extract"),
    config = list(output_path = "output/data/reports/extract/"),
    moderately_sensitive = lst(
      html = "output/data/reports/extract/*.html",
      png = "output/data/reports/extract/*.png",
    )
  ),

  action(
    name = "data_process",
    run = "r:latest analysis/data_process.R",
    needs = list("extract"),
    highly_sensitive = lst(
      rds = "output/data/data_processed.rds",
      vaxlong = "output/data/data_vaxlong.rds"
    )
  ),

  action(
    name = "data_process_long",
    run = "r:latest analysis/data_process_long.R",
    needs = list("data_process"),
    highly_sensitive = lst(
      processed = "output/data/data_long*.rds",
    )
  ),

  # action(
  #   name = "data_properties",
  #   run = "r:latest analysis/process/data_properties.R",
  #   arguments = c("output/data/data_processed.rds", "output/data_properties"),
  #   needs = list("data_process"),
  #   moderately_sensitive = lst(
  #     cohort = "output/data_properties/data_processed*.txt"
  #   )
  # ),

  action(
    name = "data_selection",
    run = "r:latest analysis/data_selection.R",
    needs = list("data_process"),
    highly_sensitive = lst(
      data = "output/data/data_cohort.rds",
      feather = "output/data/data_cohort.feather"
    ),
    moderately_sensitive = lst(
      flow = "output/data/flowchart.csv"
    )
  ),


  action(
    name = "cohort_report",
    run = "cohort-report:v3.0.0 output/data/data_cohort.feather",
    needs = list("data_selection"),
    config = list(output_path = "output/data/reports/cohort/"),
    moderately_sensitive = lst(
      html = "output/data/reports/cohort/*.html",
      png = "output/data/reports/cohort/*.png",
    )
  ),

  comment("# # # # # # # # # # # # # # # # # # #", "Descriptive stats", "# # # # # # # # # # # # # # # # # # #"),

  action(
    name = "descriptive_table1",
    run = "r:latest analysis/table1.R",
    needs = list("data_selection"),
    # highly_sensitive = lst(
    #   rds = "output/descriptive/tables/table1*.rds"
    # ),
    moderately_sensitive = lst(
      html = "output/descriptive/table1/*.html",
      csv = "output/descriptive/table1/*.csv"
    )
  ),
  #
  # action(
  #   name = "descr_irr",
  #   run = "r:latest analysis/descriptive/table_irr.R",
  #   arguments = c("output/data/data_processed.rds", "output/data_properties"),
  #   needs = list("data_selection"),
  #   highly_sensitive = lst(
  #     rds = "output/descriptive/tables/table_irr*.rds"
  #   ),
  #   moderately_sensitive = lst(
  #     html = "output/descriptive/tables/table_irr*.html",
  #     csv = "output/descriptive/tables/table_irr*.csv"
  #   )
  # ),
  #
  # action(
  #   name = "descr_km",
  #   run = "r:latest analysis/descriptive/km.R",
  #   arguments = c("output/data/data_processed.rds", "output/data_properties"),
  #   needs = list("data_selection"),
  #   highly_sensitive = lst(
  #     rds = "output/descriptive/km/plot_survival*.rds"
  #   ),
  #   moderately_sensitive = lst(
  #     png = "output/descriptive/km/plot_survival*.png",
  #     svg = "output/descriptive/km/plot_survival*.svg"
  #   )
  # ),

  action(
    name = "descriptive_vaxdate",
    run = "r:latest analysis/vax_date.R",
    needs = list("data_selection"),
    moderately_sensitive = lst(
      png = "output/descriptive/vaxdate/*.png",
      pdf = "output/descriptive/vaxdate/*.pdf",
      svg = "output/descriptive/vaxdate/*.svg"
    )
  ),

  # action(
  #   name = "descr_eventdate",
  #   run = "r:latest analysis/descriptive/event_date.R",
  #   needs = list("data_selection"),
  #   highly_sensitive = lst(
  #     rds = "output/descriptive/eventdate/*.rds"
  #   ),
  #   moderately_sensitive = lst(
  #     png = "output/descriptive/eventdate/*.png",
  #     pdf = "output/descriptive/eventdate/*.pdf",
  #     svg = "output/descriptive/eventdate/*.svg",
  #   )
  # ),


  comment("# # # # # # # # # # # # # # # # # # #", "Models", "# # # # # # # # # # # # # # # # # # #"),

  comment("###  Positive SARS-CoV-2 Test"),
  action_model("pfizer", "postest"),
  action_model("moderna", "postest"),

  comment("###  COVID-19 unplanned admission"),
  action_model("pfizer", "covidadmitted"),
  action_model("moderna", "covidadmitted"),

  comment("###  COVID-19 ICU/Critical care admission"),
  action_model("pfizer", "covidcc"),
  action_model("moderna", "covidcc"),

  comment("###  COVID-19 death"),
  action_model("pfizer", "coviddeath"),
  action_model("moderna", "coviddeath"),

  comment("# # # # # # # # # # # # # # # # # # #", "Reports", "# # # # # # # # # # # # # # # # # # #")

)


project_list <- splice(
  defaults_list,
  list(actions = actions_list)
)

## convert list to yaml, reformat comments and whitespace ----
thisproject <- as.yaml(project_list, indent=2) %>%
  # convert comment actions to comments
  convert_comment_actions() %>%
  # add one blank line before level 1 and level 2 keys
  str_replace_all("\\\n(\\w)", "\n\n\\1") %>%
  str_replace_all("\\\n\\s\\s(\\w)", "\n\n  \\1")


# if running via opensafely, check that the project on disk is the same as the project created here:
if (Sys.getenv("OPENSAFELY_BACKEND") %in% c("expectations", "tpp")){

  thisprojectsplit <- str_split(thisproject, "\n")
  currentproject <- readLines(here("project.yaml"))

  stopifnot("project.yaml is not up-to-date with create-project.R.  Run create-project.R before running further actions." = identical(thisprojectsplit, currentproject))

# if running manually, output new project as normal
} else if (Sys.getenv("OPENSAFELY_BACKEND") %in% c("")){

## output to file ----
  writeLines(thisproject, here("project.yaml"))
#yaml::write_yaml(project_list, file =here("project.yaml"))

## grab all action names and send to a txt file

names(actions_list) %>% tibble(action=.) %>%
  mutate(
    model = action==""  & lag(action!="", 1, TRUE),
    model_number = cumsum(model),
  ) %>%
  group_by(model_number) %>%
  summarise(
    sets = str_trim(paste(action, collapse=" "))
  ) %>% pull(sets) %>%
  paste(collapse="\n") %>%
  writeLines(here("actions.txt"))

# fail if backend not recognised
} else {
  stop("Backend not recognised")
}
