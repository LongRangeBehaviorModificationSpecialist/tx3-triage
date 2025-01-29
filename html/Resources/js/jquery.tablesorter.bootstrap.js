$(function() {
	var $table = $('table'),
	pagerOptions = {
		container: $(".pager"),
		output: '{startRow} - {endRow} / {filteredRows} ({totalRows})',
		fixedHeight: false,
		cssGoto: '.gotoPage',
		page: 0,
		size: 100,
		savePages: true,
		removeRows: true
	};
  
  $.tablesorter.language.button_print = "Print";
  $.tablesorter.language.button_close = "Close";
  
  $table.tablesorter({
	widthFixed : true,
	widgets: ["zebra", "filter", "print", "stickyHeaders"],
	widgetOptions : {
      stickyHeaders_offset : 50,
      stickyHeaders_filteredToTop : true,
	  filter_external : '.search',
	  filter_defaultFilter : { 1 : '~{query}' },
	  filter_columnFilters : true,
	  filter_placeholder : { search : 'Filter' },
	  filter_saveFilters : true,
	  filter_reset: '.reset',
	  print_title      : '',          // this option > caption > table id > "table"
      print_rows       : 'f',         // (a)ll, (v)isible, (f)iltered, or custom css selector
      print_columns    : 'a',         // (a)ll, (v)isible or (s)elected (columnSelector widget)
      print_extraCSS   : '',          // add any extra css definitions for the popup window here
      print_styleSheet : '../resources/css/style_print.css', // add the url of your print stylesheet
      print_now        : true,        // Open the print dialog immediately if true
      print_callback   : function(config, $table, printStyle){
        $.tablesorter.printTable.printOutput( config, $table.html(), printStyle );
      }
	}
  }).tablesorterPager(pagerOptions);

  // make search buttons work
  $('button[data-column]').on('click', function(){
	var $this = $(this),
	  totalColumns = $table[0].config.columns,
	  col = $this.data('column'), // zero-based index or "all"
	  filter = [];

	// text to add to filter
	filter[ col === 'all' ? totalColumns : col ] = $this.text();
	$table.trigger('search', [ filter ]);
	return false;
  });
  
  // make printing work
  $('.print').click(function(){
    $('.tablesorter').trigger('printTable');
  });
});