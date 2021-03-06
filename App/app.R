#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

review=read.csv("reviews.csv")[,-1]
att=read.csv("att_data_clean.csv")[,-1]
att_par=att[,1:40][,c(-2,-7)]

for (i in 1:ncol(att_par)){
  att_par[,i]=as.character(att_par[,i])
}


############################################################

pos_review=function(business_id){
  business_summary=review[review$business_id==business_id,]
  positive_parts=unlist(strsplit(as.character(business_summary$positive.words),split = ","))
  if (length(positive_parts)==0){
    return(positive_parts)
  }else{
    index=1:length(positive_parts)
    pos=cbind(index,positive_parts)
    return(pos)
  }
}

neg_review=function(business_id){
  business_summary=review[review$business_id==business_id,]
  negative_parts=unlist(strsplit(as.character(business_summary$negative.words),split = ","))
  if (length(negative_parts)==0){
    return(negative_parts)
  }else{
    index=1:length(negative_parts)
    neg=cbind(index,negative_parts)
    return(neg)
  }
}

alert = "We can't find records according to your bussiness ID. Please check your input."
Ntable = data.frame(alert)
row.names(Ntable) = NULL
colnames(Ntable) = 'NOTICE !'


alert2="We can't offer this part based on the reviews collected."
Ptable =  data.frame(alert2)
row.names(Ptable) = NULL
colnames(Ptable) = 'NOTICE !'

sug2=function(business_id){
  business_summary=att_par$dessert[att_par$business_id==business_id]
  if (business_summary == 'False'){
    return("Please provide food that are good for desserts. Your estimated rating will increase by 0.16 by doing this.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug3=function(business_id){
  business_summary=att_par$latenight[att_par$business_id==business_id]
  if (business_summary == 'False'){
    return("There's no need to make a change here.")
  }else{
    return("It is unnecessary to improve your performance on latenight meal.")
  }
}

sug4=function(business_id){
  business_summary=att_par$dinner[att_par$business_id==business_id]
  if (business_summary == 'False'){
    return("Please improve your performance on dinner meal. Your estimated rating will increase by 0.07 by doing this.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug5=function(business_id){
  business_summary=att_par$brunch[att_par$business_id==business_id]
  if (business_summary == 'False'){
    return("Please improve your performance on brunch meal. Your estimated rating will increase by 0.25 by doing this.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug6=function(business_id){
  business_summary=att_par$Caters[att_par$business_id==business_id]
  if (business_summary == 'False'){
    return("Please provide caters. Your estimated rating will increase by 0.26 by doing this.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug7=function(business_id){
  business_summary=att_par$NoiseLevel[att_par$business_id==business_id]
  if (business_summary == "'quiet'"){
    return("There's no need to make a change here.")
  }else{
    return("Please keep your environment quiet.")
  }
}

sug8=function(business_id){
  business_summary=att_par$RestaurantsTableService[att_par$business_id==business_id]
  if (business_summary == 'False'){
    return("Please provide or improve your table service. Your estimated rating will increase by 0.21 by doing this.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug9=function(business_id){
  business_summary=att_par$HasTV[att_par$business_id==business_id]
  if (business_summary == 'False'){
    return("Please provide TV in your restaurant. Your estimated rating will increase by 0.13 by doing this.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug10=function(business_id){
  business_summary=att_par$Alcohol[att_par$business_id==business_id]
  if (business_summary == "'full_bar'"){
    return("There's no need to make a change here.")
  }else{
    return("Please provide wine in your restaurant. Your estimated rating will increase by 0.09 by doing this.")
  }
}

sug11=function(business_id){
  business_summary=att_par$RestaurantsDelivery[att_par$business_id==business_id]
  if (business_summary == 'False'){
    return("Please provide or improve your delivery. Your estimated rating will increase by 0.12 by doing this.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug12=function(business_id){
  business_summary=att_par$BusinessAcceptsCreditCards[att_par$business_id==business_id]
  if (business_summary == 'True'){
    return("Please improve your credit card supporting service.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug13=function(business_id){
  business_summary=att_par$WheelchairAccessible[att_par$business_id==business_id]
  if (business_summary == 'True'){
    return("Please forbid wheel chair in your restaurant.")
  }else{
    return("There's no need to make a change here.")
  }
}

sug14=function(business_id){
  business_summary=att_par$park[att_par$business_id==business_id]
  if (business_summary == '0'){
    return("If possible, please provide parking lots. Your estimated rating will increase by 0.08 by doing this.")
  }else{
    return("There's no need to make a change here.")
  }
}

im=function(business_id){
  if (att_par$NoiseLevel[att_par$business_id==business_id]!="'quiet'"){
    return("NoiseLevel.jpg") 
  } else if (att_par$RestaurantsTableService[att_par$business_id==business_id]=='False'){
    return("RestaurantsTableService.jpg")
  } else if (att_par$dessert[att_par$business_id==business_id]=='False'){
    return("dessert.jpg")
  } else {
    return("HasTV.jpg")
  }
}


# Define UI for application that draws a histogram
ui <- fluidPage(
  headerPanel('Suggestions for Business Owners'),
  sidebarPanel(
    textInput(inputId = 'Business', label =  'Business ID', 'voZnDQs6Hs3YpNcS-9TALg'),
    helpText("Please input your business ID."),
    submitButton("Submit")
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("about",
               h4(textOutput("about1")),
               h4(textOutput("about2")),
               h4(textOutput("about3"))
      ),
      tabPanel("attribute which can mostly improve your rating",
               imageOutput("myimage")
      ),
      tabPanel("suggestions based on attribute",
               h3(textOutput("att1")),
               h4(textOutput("sug1")),
               h3(textOutput("att2")),
               h4(textOutput("sug2")),
               h3(textOutput("att3")),
               h4(textOutput("sug3")),
               h3(textOutput("att4")),
               h4(textOutput("sug4")),
               h3(textOutput("att5")),
               h4(textOutput("sug5")),
               h3(textOutput("att6")),
               h4(textOutput("sug6")),
               h3(textOutput("att7")),
               h4(textOutput("sug7")),
               h3(textOutput("att8")),
               h4(textOutput("sug8")),
               h3(textOutput("att9")),
               h4(textOutput("sug9")),
               h3(textOutput("att10")),
               h4(textOutput("sug10")),
               h3(textOutput("att11")),
               h4(textOutput("sug11")),
               h3(textOutput("att12")),
               h4(textOutput("sug12")),
               h3(textOutput("att13")),
               h4(textOutput("sug13")),
               h3(textOutput("att14")),
               h4(textOutput("sug14"))
      ),
      tabPanel("positive parts in reviews",
               DT::dataTableOutput("pos_review")
      ),
      tabPanel("negative parts in reviews",
               DT::dataTableOutput("neg_review")
      )
    )
  )
)

server <- function(input, output) {
    output$about1 = renderText({
      paste("This app is designed to offer suggestions for business owners of Mexican restaurants to improve their ratings on Yelp.") 
    })
    output$about2 = renderText({
      paste("Input your business ID and click on the tab panels to see our suggestions for your business.")
    })
    output$about3 = renderText({
      paste("The second panel is a heat map about the attributes which can mostly improve your rating. The third panel is our suggestions based on all attributes which have significant influence on rating and the rest of the panels are your negative and positive aspects according to the consumers' reviews.")
    })
    output$sug1 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Please provide intimate, hipster, divey or trendy ambience. Your estimated rating will increase by 0.49 if you provide intimate ambience, increase by 0.25 if you provide hipster ambience, increase by 0.22 if you provide divey ambience and increase by 0.25 if you provide trendy ambience.")
      } else {
        paste("")
      }
    })
    output$sug2 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug2(input$Business))
      } else {
        paste("")
      }
    })
    output$sug3 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug3(input$Business))
      } else {
        paste("")
      }
    })
    output$sug4 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug4(input$Business))
      } else {
        paste("")
      }
    })
    output$sug5 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug5(input$Business))
      } else {
        paste("")
      }
    })
    output$sug6 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug6(input$Business))
      } else {
        paste("")
      }
    })
    output$sug7 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug7(input$Business))
      } else {
        paste("")
      }
    })
    output$sug8 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug8(input$Business))
      } else {
        paste("")
      }
    })
    output$sug9 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug9(input$Business))
      } else {
        paste("")
      }
    })
    output$sug10 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug10(input$Business))
      } else {
        paste(" ")
      }
    })
    output$sug11 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug11(input$Business))
      } else {
        paste(" ")
      }
    })
    output$sug12 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug12(input$Business))
      } else {
        paste(" ")
      }
    })
    output$sug13 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug13(input$Business))
      } else {
        paste(" ")
      }
    })
    output$sug14 = renderText({
      if (input$Business %in% att_par$business_id){
        paste(sug14(input$Business))
      } else {
        paste(" ")
      }
    })
    output$att1 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Ambience:")
      } else {
        paste(alert)
      }
    })
    output$att2 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Dessert:")
      } else {
        paste("")
      }
    })
    output$att3 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Latenight Meal:")
      } else {
        paste("")
      }
    })
    output$att4 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Dinner Meal:")
      } else {
        paste("")
      }
    })
    output$att5 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Brunch Meal: ")
      } else {
        paste("")
      }
    })
    output$att6 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Caters: ")
      } else {
        paste("")
      }
    })
    output$att7 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Noise Level: ")
      } else {
        paste("")
      }
    })
    output$att8 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Table Service: ")
      } else {
        paste("")
      }
    })
    output$att9 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("TV: ")
      } else {
        paste("")
      }
    })
    output$att10 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Alcohol:")
      } else {
        paste("")
      }
    })
    output$att11 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Delivery: ")
      } else {
        paste("")
      }
    })
    output$att12 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Payment Methods: ")
      } else {
        paste("")
      }
    })
    output$att13 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Wheel Chair: ")
      } else {
        paste("")
      }
    })
    output$att14 = renderText({
      if (input$Business %in% att_par$business_id){
        paste("Parking lot: ")
      } else {
        paste("")
      }
    })
    output$pos_review = DT::renderDataTable({
      if ((input$Business %in% review$business_id) == FALSE){
        DT::datatable(Ntable,options = list(paging = FALSE),rownames=FALSE) 
      }else if (length(pos_review(input$Business))==0){
        DT::datatable(Ptable,options = list(paging = FALSE),rownames=FALSE)
      }else{
        DT::datatable(pos_review(input$Business),options = list(paging = FALSE),caption = 'Your positive parts wrt reviews:')
      }
    })
    output$neg_review = DT::renderDataTable({
      if ((input$Business %in% review$business_id) == FALSE){
        DT::datatable(Ntable,options = list(paging = FALSE),rownames=FALSE) 
      }else if (length(neg_review(input$Business))==0){
        DT::datatable(Ptable,options = list(paging = FALSE),rownames=FALSE)
      }else{
        DT::datatable(neg_review(input$Business),options = list(paging = FALSE),caption = 'Your negative parts wrt reviews:')
      }
    })
    output$myimage = renderImage({
    if (input$Business %in% att_par$business_id == F){
      list(src = 'alert.jpg',
           contentType = 'image/jpg',
           width = 700,
           height = 200)
    } else {
      list(src = im(input$Business),
           contentType = 'image/jpg',
           width = 600,
           height = 500)
    }
    },deleteFile = FALSE)
}

# Run the application 
shinyApp(ui = ui, server = server)

