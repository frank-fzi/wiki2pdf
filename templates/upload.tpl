<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#pic">Upload</a></li>
  <li class="disabled"><a data-toggle="tab" id="" href="">Editor</a></li>
  <li class="disabled"><a data-toggle="tab" id="" href="">Export</a></li>
</ul>

<div class="tab-content">
  <div id="pic" class="tab-pane fade in active">
  	<div class="container tabelement">
  		<div class="row">
  			<div class="text-center">
  				<div id="pages"></div>
			</div>
  		</div>
  		<div id="content" class="row">
  			<form class="form" method="POST" action="##FORMURL##">

	        <label for="inputURL" class="sr-only">URL</label>
	        <input type="url" id="inputURL" name="url" class="form-control" placeholder="URL" required autofocus>

	        <button class="btn btn-lg btn-primary btn-block" type="submit">Start</button>
	      </form>
  		</div>
  	</div>
  </div>
  <div id="export" class="tab-pane fade">
    <h3>Export</h3>
    <div class="container tabelement">
    	<div id="row">
    	<textarea disabled style="width:100%; height:60%;" id="TfExport"></textarea>
    	</div>
    </div>
  </div>
</div>