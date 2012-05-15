<%@ include file="/WEB-INF/views/includes/taglibs.jsp"%>

<spring:url scope="page" var="jqueryJavascriptUrl" value="/resources/js/jquery-1.7.1.js"/>
<spring:url scope="page" var="jqueryTmplJavascriptUrl" value="/resources/js/jquery.tmpl.min.js"/>
<spring:url scope="page" var="jqueryAtmosphereUrl" value="/resources/js/jquery.atmosphere.js"/>
<spring:url scope="page" var="bootstrapUrl" value="/resources/js/bootstrap.js"/>
<spring:url scope="page" var="bootstrapCssUrl" value="/resources/css/bootstrap.css"/>
<spring:url scope="page" var="bootstrapResponsiveCssUrl" value="/resources/css/bootstrap-responsive.css"/>

<!DOCTYPE HTML>
<html>
    <head>

        <title>Welcome to Spring Web MVC - Atmosphere Sample</title>

        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<script src="${pageScope.jqueryJavascriptUrl}"></script>
		<script src="${pageScope.jqueryTmplJavascriptUrl}"></script>
		<script src="${pageScope.jqueryAtmosphereUrl}"></script>
		<script src="${pageScope.bootstrapUrl}"></script>
		<link rel="stylesheet" href="${pageScope.bootstrapCssUrl}"/>
		<link rel="stylesheet" href="${pageScope.bootstrapResponsiveCssUrl}"/>
    </head>
    <body>
    	<section id="view-twitter-feed">
	        <div class="container-fluid">
	        	<header class="page-header">
	                <h3>
	                    Twitter Demo w/ SpringMVC and Atmosphere 
	                </h3>
	            </header>
	        	<div class="row-fluid">
	        		<div class="span2">
		            	<header class="page-header">
	                        <h4>Stats</h4>
	                    </header>
		                <table id="asynchHttpStats" class="table-condensed">
		                    <thead>
		                        <tr>
		                            <th></th>
		                            <th></th>
		                        </tr>
		                    </thead>
		                    <tbody>
		                        <tr>
		                            <td>Protocol</td>
		                            <td id="transportType">N/A</td>
		                        </tr>
		                    </tbody>
		                </table>
		                <table id="chartableStats" class="table-condensed">
		                    <thead>
		                        <tr>
		                            <th scope="col"></th>
		                            <th scope="col"></th>
		                        </tr>
		                    </thead>
		                    <tbody>
		                        <tr>
		                            <th scope="row" style="color: #1751A7"># of Callbacks</th>
		                            <td id="numberOfCallbackInvocations">0</td>
		                        </tr>
		                        <tr>
		                            <th scope="row" style="color: #8AA717"># Tweets</th>
		                            <td id="numberOfTweets">0</td>
		                        </tr>
		                        <tr>
		                            <th scope="row" style="color: #A74217"># Errors</th>
		                            <td id="numberOfErrors">0</td>
		                        </tr>
		                    </tbody>
		                </table>
		            </div>
	        		<div class="span10">
		        		<table class="table-striped table-bordered">
			            	<thead>
		                        <tr>
		                            <th width="800">Twitter Messages</th>
		                        </tr>
		                    </thead>
		                    <tbody id="twitterMessages">
		                    	<tr id="placeHolder">
		                    		<td>Searching...</td>
		                    	</tr>
		                    </tbody>
		            	</table>
	        		</div>
	        	</div>
        	</div>
       	</section>
		
        <script id="template" type="text/x-jquery-tmpl">
        <tr>
			<td>
				<img align="left" alt='\${fromUser}' title='\${fromUser}' src='\${profileImageUrl}' width='48' height='48'>
					<div>
						&nbsp;&nbsp;&nbsp;<c:out value='\${text}'/>
					</div>
			</td>
		</tr>
        </script>

        <script type="text/javascript">

            $(function() {

                var asyncHttpStatistics = {
                        transportType: 'N/A',
                        responseState: 'N/A',
                        numberOfCallbackInvocations: 0,
                        numberOfTweets: 0,
                        numberOfErrors: 0
                    };

                function refresh() {

                    console.log("Refreshing data tables...");

                    $('#transportType').html(asyncHttpStatistics.transportType);
                    $('#responseState').html(asyncHttpStatistics.responseState);
                    $('#numberOfCallbackInvocations').html(asyncHttpStatistics.numberOfCallbackInvocations);
                    $('#numberOfTweets').html(asyncHttpStatistics.numberOfTweets);
                    $('#numberOfErrors').html(asyncHttpStatistics.numberOfErrors);

                }

                var socket = $.atmosphere;
                var request = new $.atmosphere.AtmosphereRequest();
                request.transport = 'websocket';
                request.url = "<c:url value='/twitter/concurrency'/>";
                request.contentType = "application/json";
                request.fallbackTransport = 'polling';
                request.callback = onMessage;
                
                function onMessage(response)
                {
                    asyncHttpStatistics.numberOfCallbackInvocations++;
                    asyncHttpStatistics.transportType = response.transport;
                    asyncHttpStatistics.responseState = response.responseState;

                    $.atmosphere.log('info', ["response.state: " + response.state]);
                    $.atmosphere.log('info', ["response.transport: " + response.transport]);
                    $.atmosphere.log('info', ["response.responseBody: " + response.responseBody]);
                    if (response.status == 200) {
                        var data = response.responseBody;

                        if (data) {

                            try {
                                var result =  $.parseJSON(data);

                                var visible = $('#placeHolder').is(':visible');

                                if (result.length > 0 && visible) {
                                    $("#placeHolder").fadeOut();
                                }

                                asyncHttpStatistics.numberOfTweets = asyncHttpStatistics.numberOfTweets + result.length;

                                $( "#template" ).tmpl( result ).hide().prependTo( "#twitterMessages").fadeIn();

                            } catch (error) {
                                asyncHttpStatistics.numberOfErrors++;
                                console.log("An error ocurred: " + error);
                            }
                        } else {
                            console.log("response.responseBody is null - ignoring.");
                        }
                    }

                    refresh();
                };

                var subSocket = socket.subscribe(request);

            });


        </script>
    </body>
</html>