context("Search data packages")

testthat::test_that("Query parser is replaced", {
  
  query <- 'q="air+temperature"+AND+title:arctic&fq=-scope:ecotrends&fl=packageid,title,score&sort=score,desc&sort=packageid,asc&defType=edismax&start=0&rows=10'
  res <- search_data_packages(query)
  
  query <- "https://pasta.lternet.edu/package/search/eml?defType=edismax&q=%22air+temperature%22+AND+title:arctic&fl=packageid,title,score&sort=score,desc&sort=packageid,asc&defType=edismax&start=0&rows=10&fq=scope:ecotrends"
  res <- search_data_packages(query)
  
  query <- "https://pasta.lternet.edu/package/search/eml?defType=edismax&q=%22air+temperature%22+AND+title:arctic&fl=packageid,title,score&sort=score,desc&sort=packageid,asc&defType=edismax&start=0&rows=10&fq=scope:ecotrends&fq=scope:lter-landsat"
  res <- search_data_packages(query)

  # TODO determine how (what character) to include multiple items within &fq=.
  # TODO add to @param query ... To filter out the NUMBER of lter-landsat and ecotrends data packages, include the terms ... TERMS. Alternatively, do the regexpr work (and testing) to control these w/args.
  
  res <- search_data_packages(query)
  
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("reservation" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("docid", "principal", "dateReserved")
  expect_true(all(children_found %in% children_expected))
})


testthat::test_that("Test attributes of returned object", {
  query <- 'q="air+temperature"+AND+title:arctic&fq=-scope:ecotrends&fl=packageid,title,score&sort=score,desc&sort=packageid,asc&defType=edismax&start=0&rows=10'
  
  query <- "q=keyword:disturbance&fl=id"
  res <- search_data_packages(query)
  
  query <- 'q="air+temperature"+AND+title:arctic&fl=packageid,title,score&sort=score,desc&sort=packageid,asc&defType=edismax&start=0&rows=10'
  
  query <- "https://pasta.lternet.edu/package/search/eml?defType=edismax&q=%22air+temperature%22+AND+title:arctic&fl=packageid,title,score&sort=score,desc&sort=packageid,asc&defType=edismax&start=0&rows=10&fq=scope:ecotrends&fq=scope:lter-landsat"
  query <- "https://pasta.lternet.edu/package/search/eml?defType=edismax&q=%22air+temperature%22+AND+title:arctic&fl=packageid,title,score&sort=score,desc&sort=packageid,asc&defType=edismax&start=0&rows=10&fq=-scope:lter-landsat"
  
  # TODO determine how (what character) to include multiple items within &fq=.
  # TODO add to @param query ... To filter out the NUMBER of lter-landsat and ecotrends data packages, include the terms ... TERMS. Alternatively, do the regexpr work (and testing) to control these w/args.
  
  res <- search_data_packages(query)
  
  expect_true(all(class(res) %in% c("xml_document", "xml_node")))
  expect_true("reservation" %in% xml2::xml_name(xml2::xml_children(res)))
  children_found <- xml2::xml_name(xml2::xml_children(xml2::xml_children(res)[1]))
  children_expected <- c("docid", "principal", "dateReserved")
  expect_true(all(children_found %in% children_expected))
})

# namespace strip checker
xml2::xml_find_all(res, ".//articleUrl")
#
