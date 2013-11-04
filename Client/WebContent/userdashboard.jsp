<jsp:include page="header.jsp" />

<%@ page import="sy.ui.UIUtil"%>
<%
	UIUtil.authenticate(session, request, response);

	String searchTerm = "", escapedSearchTerm = "";
	Boolean isSearchPage = false;
	try {
		searchTerm = request.getParameter("searchTerm");
		escapedSearchTerm = searchTerm.replace("\"", "\\\"");
		isSearchPage = true;
	} catch (Exception ex) {
	}
%>

<script>
	$(function() {
		//select nav
		NavUtil.init('#movieNav');

		for (var i = 0; i < ENUM.GENRES.length; i++) {
			$('#genres').append('<option>' + ENUM.GENRES[i] + '</option>');
		}

		//rendering
		var tmplRowMovie = $('#tmplRowMovie').html(),
		tmplRowRental = $('#tmplRowRental').html(),
		renderRental = false;
		
		function renderList(lstMovie) {
			for (var i = 0; i < lstMovie.length; i++){
				$('#tblMovie tbody').append(
						Mustache.render(tmplRowMovie, lstMovie[i]));
				
				if (!renderRental && $('#tblRental tbody').children().length < 5)
					$('#tblRental tbody').append(
							Mustache.render(tmplRowRental, lstMovie[i]));
			}
				
			
			renderRental =true;
		}
		
		tmplRowRental

		//hook up events
		$('.btn-show-more').on('click', function() {
			$.get(URL.DASHBOARD_CONTROLLER, {
				cmd : "getmovies",
				<%if (!isSearchPage) {%>
				genre : $('#genres').val(),
				<%} else {%>
				searchTerm : "<%=escapedSearchTerm%>",
				<%}%>
				from : $('.rentry').length,
				pagesize : 25
			}, function(lstUsers) {
				renderList(lstUsers);
				$('.totalRecord').html($('.rentry').length);
			}, 'json');
		}).click();

		$('#genres').change(function() {
			$('#tblMovie tbody').children().remove();
			$('.btn-show-more').click();
		});
		
		$('#frmSearch').submit(function(){
			if ($('#searchTerm').val() == ""){
				alert("Please enter something to search.");
				return false;
			}
		});
		
		//btnRent
	});
</script>

<div class="row-fluid">
	<div class="span5">
		<div id="yourrental">
			<h4 class="text-info">Movies you rented</h4>
			<table id="tblRental" class="table">
				<thead>
					<tr>
						<th>Movie Name</th>
						<th>Release Date</th>
						<th>Rent Amount</th>
						<th>Rented Date</th>
						<th>Expiration Date</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		<div id="billinginfo">
			<h4 class="text-info">Billing Information:</h4>
			<div class="control-group">
				<label class="control-label">Monthly Subscription:</label> <span>$
					15.00</span>
			</div>
			<div class="control-group">
				<label class="control-label">Balance:</label> <span>$ 2.00</span>
			</div>
			<div class="control-group">
				<label class="control-label">Total Outstanding:</label> <span>$
					5.00</span>
			</div>
		</div>
	</div>

	<div id="moviemanagement" class="span7">
		<h4 class="text-info">Rent A New Movie</h4>
		<a class="btn pull-right" href="movieform.jsp">Add Movie</a>
		<h4 class="muted">
			Showing <span class="totalRecord"></span> Movies
		</h4>

		<div class="control-group" style="margin: 15px 0 15px 0">
			<%
				if (!isSearchPage) {
			%>
			<label class="control-label">Genre Filtering:</label> <select
				id="genres">
				<option value="">Any Genre</option>
			</select>
			<%
				}
			%>


			<div class="input-append pull-right">
				<form id="frmSearch" method="get" action="moviemanagement.jsp">
					<input class="input-xlarge" id="searchTerm" name="searchTerm"
						placeholder="Type something to search" type="text"
						value="<%=searchTerm == null ? "" : searchTerm%>" /> <input
						type="submit" class="btn" value="Search" />
				</form>
			</div>
		</div>


		<table id="tblMovie" class="table">
			<thead>
				<tr>
					<th>Movie Name</th>
					<th>Release Date</th>
					<th>Rent Amount</th>
					<th>Category</th>
					<th>Available Copies</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>

		<h4 class="muted">
			Showing <span class="totalRecord"></span> Movies
		</h4>
		<a class="btn btn-show-more">Show more</a>
	</div>
</div>
<script id="tmplRowMovie" type="mustache">
<tr class="rentry">
<td>{{movieName}}</td>
<td>{{releaseDate}}</td>
<td>$ {{rentAmount}}</td>
<td>{{category}}</td>
<td>{{availableCopies}}</td>
<td>
	<a><i class="icon-circle-arrow-down btnRent"></i></a>
</td>
<tr>
</script>


<script id="tmplRowRental" type="mustache">
<tr class="rentry">
<td>{{movieName}}</td>
<td>{{releaseDate}}</td>
<td>{{rentAmount}}</td>
<td>11/01/2013</td>
<td>11/02/2013</td>
<tr>
</script>
<jsp:include page="footer.jsp" />