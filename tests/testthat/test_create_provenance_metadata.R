context('Create provenance metadata')
library(EDIutils)

testthat::test_that('Test for object attributes', {
  
  # Define arguments
  
  ds_title <- 'Some dataset title'
  ds_online_description <- 'Description of online resourceURL'
  ds_url <- 'https://url.of.data.resource'
  
  ds_creator = list(
    list(givenName = 'Jane', 
         surName = 'Scientist',
         organizationName = 'Some organization name',
         electronicMailAddress = 'jsci@email.edu'
    ), 
    list(givenName = 'Bill', 
         surName = 'Sciguy',
         electronicMailAddress = 'bsg@email.edu'
    )
  )
  
  ds_contact = list(
    list(givenName = 'Jane', 
         surName = 'Scientist',
         organizationName = 'Some organization name',
         electronicMailAddress = 'jsci@email.edu'
    )
  )

  # Run test
  
  expect_equal(
    class(
      create_provenance_metadata(
        title = ds_title,
        creator = ds_creator,
        online.description = ds_online_description,
        url = ds_url,
        contact = ds_contact
      )
    ),
    c('xml_document', 'xml_node')
  )
  
})
