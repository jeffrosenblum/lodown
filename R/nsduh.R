get_catalog_nsduh <-
	function( data_name = "nsduh" , output_dir , ... ){

	catalog <- get_catalog_icpsr( "00064" , bundle_preference = "stata" )
	
	catalog$unzip_folder <- paste0( output_dir , "/" , catalog$temporalCoverage , ifelse( catalog$dataset_name %in% c( "Part A" , "Part B" ) , paste0( "/" , tolower( catalog$dataset_name ) ) , "" ) )

	catalog$output_filename <- paste0( output_dir , "/" , catalog$temporalCoverage , " " , ifelse( catalog$dataset_name %in% c( "Part A" , "Part B" ) , tolower( catalog$dataset_name ) , "main" ) , ".rds" )

	catalog

}


lodown_nsduh <-
	function( data_name = "nsduh" , catalog , ... ){

		on.exit( print( catalog ) )
	
		lodown_icpsr( data_name = data_name , catalog , ... )

		for( i in seq_len( nrow( catalog ) ) ){
		
			# find stata file within unzipped path
			stata_files <- grep( "\\.dta$" , list.files( catalog[ i , 'unzip_folder' ] , full.names = TRUE ) , value = TRUE )
			
			stopifnot( length( stata_files ) == 1 )
			
			x <- icpsr_stata( stata_files , catalog_entry = catalog[ i , ] )

			names( x ) <- tolower( names( x ) )
			
			catalog[ i , 'case_count' ] <- nrow( x )
			
			saveRDS( x , file = catalog[ i , 'output_filename' ] )
			
			cat( paste0( data_name , " catalog entry " , i , " of " , nrow( catalog ) , " stored at '" , catalog[ i , 'output_filename' ] , "'\r\n\n" ) )
		
		}

		on.exit()
		
		catalog

	}

