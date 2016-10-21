<ul class="nav nav-tabs">
  <li><a data-toggle="tab" href="#pic">Upload</a></li>
  <li class="active"><a data-toggle="tab" href="#pic">Bild</a></li>
  <li><a data-toggle="tab" id="exporttab" href="#export">Export</a></li>
</ul>



<div class="tab-content">
		  <div id="pic" class="tab-pane fade in active">
		  	<div class="container tabelement">
		  		<div class="row">
		  			<div class="text-center">
		  				<div id="pages">
		  				</div>
					</div>
		  		</div>
		  		<div id="content" class="row">
		  			<div id="controllpanel">
						<button class="" id="addtext">Add Text</button>
						<button class="" id="addbool">Add True/False-Checkbox</button>
						<button class="" id="addcheckbox">Add Checkbox</button>
		  			</div>
		  			<div id="scroll">
					    <canvas id="canvas" style="width: 100%; height: 100%;" ></canvas>
					</div>
		  		</div>
		  	</div>
		  </div>
		  <div id="export" class="tab-pane fade">
		    <h3>Export</h3>
		    <div class="container tabelement">
		    	<div id="row">
		    	<textarea disabled style="width:100%; height:60%; min-height: 400px;" id="TfExport"></textarea>
		    	</div>
		    </div>
	  </div>
</div>
<div id="text-controls" class="hidden controlwindow">
	<label for="font-family" style="display:inline-block">Font family:</label>
	<select id="font-family" class="btn-object-action" bind-value-to="fontFamily">
		<option value="arial">Arial</option>
		<option value="helvetica" selected="">Helvetica</option>
		<option value="myriad pro">Myriad Pro</option>
		<option value="delicious">Delicious</option>
		<option value="verdana">Verdana</option>
		<option value="georgia">Georgia</option>
		<option value="courier">Courier</option>
		<option value="comic sans ms">Comic Sans MS</option>
		<option value="impact">Impact</option>
		<option value="monaco">Monaco</option>
		<option value="optima">Optima</option>
		<option value="hoefler text">Hoefler Text</option>
		<option value="plaster">Plaster</option>
		<option value="engagement">Engagement</option>
	</select>
	<button type="button" class="btn btn-object-action" id="text-cmd-duplicate">
		<i class="fa fa-copy"></i>
	</button>
	<button type="button" class="btn btn-object-action" id="text-cmd-delete">
		<i class="fa fa-remove"></i>
	</button>
	<br>
	<div>
		<label for="text-font-size">Font size:</label>
		<input type="range" value="" min="1" max="120" step="1" id="text-font-size" class="btn-object-action" bind-value-to="fontSize">
		<div id="fontSizeLabel">12</div>
		</div>
		<div>
		<label class="" for="text-line-height">Line height:</label>
		<input class="" type="range" value="" min="0" max="10" step="0.1" id="text-line-height" class="btn-object-action" bind-value-to="lineHeight">
	</div>
	<div>
		<button type="button" class="btn btn-object-action" id="text-cmd-bold">
		Bold
		</button>
		<button type="button" class="btn btn-object-action" id="text-cmd-italic">
		Italic
		</button>
		<button type="button" class="btn btn-object-action" id="text-cmd-underline">
		Underline
		</button>
		<button type="button" class="btn btn-object-action" id="text-cmd-linethrough">
		Linethrough
		</button>
		<button type="button" class="btn btn-object-action" id="text-cmd-overline">
		Overline
		</button>
	</div>
	<div class="" style="margin-top: 10px;">
		<button type="button" class="btn btn-object-action" id="text-cmd-addspace">
		+
		</button>
		<button type="button" class="btn btn-object-action" id="text-cmd-removespace">
		-
		</button>
	</div>
	<div class="" style="margin-top: 10px;">
		<button type="button" class="btn btn-object-action" id="text-cmd-addspacex5">
		+++++
		</button>
		<button type="button" class="btn btn-object-action" id="text-cmd-removespacex5">
		------
		</button>
	</div>
</div>
<div id="bool-controls" class="hidden controlwindow">
 	<div>
        <label for="boolVarname">Varname: </label>
        <input type="text" name="boolVarname" id="boolVarname">
        <button class="btn btn-object-action" type="button"><i class="fa fa-copy" id="bool-cmd-duplicate"></i></button>
        <button class="btn btn-object-action" type="button"><i class="fa fa-remove" id="bool-cmd-delete"></i></button>
    </div>
    <div>
    	<div class="exmplContainer" id="exampleDblBool">
    		<div class="exmplContainerSection" style="float: left;">
    			(Yes)
    			<div id="exmplYes"></div>
    		</div>
    		<div class="exmplContainerSection" style="float: right;">
    			(No)
    			<div id="exmplNo"></div>
    		</div>
    	</div>
    </div>
</div>






		<script type="text/javascript">
		$( "#text-controls" ).draggable();
		$( "#bool-controls" ).draggable();

		
		var canvasWidth = 1050;
		var canvasHeight = 1485;
		var pages = [];
		var bgPages = ##pages##;

		var canvas = initCanvas('canvas', 'scroll', '##image_basepath##' + bgPages[0]);
		
		var noOfPages = ##pagecount##;

		var actPage = 1;
		var constructElements = [];
		var exported = [];
		function initCanvas(canvasID, scrollID, imgSrc){
			//canvas = new fabric.CanvasWithViewport(canvasID);
			var newcanvas = new fabric.Canvas(canvasID);



			newcanvas.setWidth(canvasWidth);
			newcanvas.setHeight(canvasHeight);

			fabric.util.addListener(document.getElementById(scrollID), 'scroll', function () {
			    newcanvas.calcOffset();
			});

			var img = new Image();
			img.onload = function(){
			   newcanvas.setBackgroundImage(img.src, newcanvas.renderAll.bind(newcanvas), {
			            originX: 'left',
			            originY: 'top',
			            left: 0,
			            top: 0,
			            width: canvasWidth,
			            height: canvasHeight,
			        });
			};
			img.src = imgSrc;



	        newcanvas.selectionColor = 'rgba(195,196,255,0.3)';
	        newcanvas.selectionBorderColor = 'gray';
	        newcanvas.selectionLineWidth = 2;
			newcanvas = addMouseListener2Canvas(newcanvas);
	        return newcanvas;
		}






        $('#pages').bootpag({//pageination
	            total: noOfPages
	        }).on("page", function(event, /* page number here */ num){
	        	pages[actPage] = canvas.toJSON(['id']);
	        	canvas.clear();
	        	actPage = num;
	        	console.log(pages[actPage]);
	        	if(typeof (pages[actPage]) == 'undefined'){
					console.log("Init Canvas for Page " + actPage);
					canvas = initCanvas('canvas', 'scroll', '##image_basepath##' + bgPages[actPage-1]);
	        	}else{
	        		console.log("Reload Canvas from Page " + actPage);
	        		canvas = canvas.loadFromJSON(pages[actPage], canvas.renderAll.bind(canvas));
	        	}
	        	console.log(canvas);
	        	canvas.renderAll();
	        	canvas = addMouseListener2Canvas(canvas);
	        	
        });

		function importCanvas(newcanvas){
			var canvas = new fabric.Canvas();
			canvas.clear();
			canvas.loadFromJSON(newcanvas, canvas.renderAll.bind(canvas));
			console.log(canvas);
		}

		function replaceCanvas(newcanvas){
			var old = canvas.canvas.toJSON(['id']);
			importCanvas(newcanvas);
			return old;
		}
		



		function addMouseListener2Canvas(tmpcanvas){
			tmpcanvas.observe('mouse:down', function(){

				var Get_obj = tmpcanvas.getActiveObject();
				//do your stuff here by getting active object on clicking on it.
				if(tmpcanvas.getActiveObject() != null){
					console.log(tmpcanvas.getActiveObject().get('type'));
					console.log(tmpcanvas.getActiveObject());
					if(tmpcanvas.getActiveObject().get('type') == 'textbox'){
						initFontMenu();
						enableFontMenu();
						disableBoolMenu();
					}else if(tmpcanvas.getActiveObject().get('type') == 'rect'){
						initBoolMenu();
						enableBoolMenu();
						disableFontMenu();
					}else{
						disableFontMenu();
						disableBoolMenu();
					}
				}else{
					disableFontMenu();
					disableBoolMenu();
				}
			});

			return tmpcanvas;
		}






		$( "#text-cmd-addspace" ).click(function() {
			addspace();
		});

		$( "#text-cmd-addspacex5" ).click(function() {
			addspace();
			addspace();
			addspace();
			addspace();
			addspace();
		});

		function addspace(){
			canvas.getActiveObject().set('text', canvas.getActiveObject().get('text') + ' _');
			canvas.renderAll();
		}

		$( "#text-cmd-removespace" ).click(function() {
			removespace();
		});
		$( "#text-cmd-removespacex5" ).click(function() {
			removespace();
			removespace();
			removespace();
			removespace();
			removespace();
		});

		function removespace(){
			text = canvas.getActiveObject().get('text');
			if(text.substring(text.length-2, text.length) == " _"){
				newtext = text.substring(0, text.length-2);
				console.log("new text: " + newtext);
				canvas.getActiveObject().set('text', newtext);
				canvas.renderAll();
			}
		}


		$( "#text-cmd-duplicate" ).click(function() {
			var object = fabric.util.object.clone(canvas.getActiveObject());
			object.set("top", object.top+5);
			object.set("left", object.left+5);
			canvas.add(object);
		});

		$( "#text-cmd-delete" ).click(function() {
			deleteActCanvasObject();
		});

		$( "#bool-cmd-delete" ).click(function() {
			deleteActCanvasObject();
		});

		function deleteActCanvasObject(){
			if (confirm('Are you sure you want to delete this item?')) {
				deleteContructionElementByHash(canvas.getActiveObject().get('id').toString().replace('_n', '').replace('_j', ''));
	   			canvas.getActiveObject().remove();
				disableFontMenu();
			} 
		}

		function deleteContructionElementByHash(hash){
			element_id = "";
			jQuery.each( constructElements, function( i, val ) {
				if(hash == val['hash']){
					element_id = i;
				}
			});
			constructElements.splice(element_id , 1);
		}

		$( "#exporttab" ).click(function() {
			generateExport();
		});

		
		$( "#addbool" ).click(function() {
			var varname = prompt("Bitte Variablennamen eingeben", "Name");
			console.log("New Bool-Element" + varname);
			var hash = randomHashCode(varname);
			console.log("Hash for Bool: " + hash);
			var element =  {
				"type" : "bool",
				"hash": hash,
			   	"varname": varname,
			   	"page" : actPage,
            };
			constructElements.push(element);
			if(varname != null && varname != ""){

				var rect_yes = new fabric.Rect({
				    width: 80,
				    height: 80,
				    fill: '#5F925F',
					left: 100, 
					top: 100 ,
				    hasRotatingPoint: false,
				    id: hash + "_j",
				});
				canvas.add(rect_yes);

				var rect_no = new fabric.Rect({
				    width: 80,
				    height: 80,
				    fill: '#7E4848',
					left: 200, 
					top: 100 ,
				    hasRotatingPoint: false,
				    id: hash + "_n",
				});
				canvas.add(rect_no);

			}

		  return false;
		});


		$( "#addcheckbox" ).click(function() {
			var varname = prompt("Bitte Variablennamen eingeben", "Name");
			console.log("New Checkbox-Element" + varname);
			var hash = randomHashCode(varname);
			console.log("Hash for Bool: " + hash);
			var element =  {
				"type" : "checkbox",
			   	"hash": hash,
			   	"varname": varname,
			   	"page" : actPage,
            };
			constructElements.push(element);
			if(varname != null && varname != ""){

				var rect = new fabric.Rect({
				    width: 80,
				    height: 80,
				    fill: '#FF9800',
					left: 200, 
					top: 100 ,
				    hasRotatingPoint: false,
				    id: hash,
				});
				canvas.add(rect);

			}

		  return false;
		});


		$( "#addtext" ).click(function() {
			var varname = prompt("Bitte Variablennamen eingeben", "Name");
			console.log(varname);
			if(varname != null && varname != ""){
		        /*canvas.add(new fabric.IText(varname, { 
				  fontFamily: 'impact',
				  left: 100, 
				  top: 100 ,
				  hasRotatingPoint: false,
				  hasControls: true,
				}));*/
				var hash = randomHashCode(varname);
				var element =  {
					"type" : "text",
				   	"hash": hash,
				   	"varname": varname,
				   	"page" : actPage,
	            };
				constructElements.push(element);

				canvas.add(new fabric.Textbox(varname, {
					width:250,
					fontFamily: 'arial',
					left: 100, 
					top: 100 ,
					hasRotatingPoint: false,
					id: hash,
				}));
				canvas.renderAll();
			}

		  return false;
		});

		function disableBoolMenu() {
    		$( "#bool-controls .btn-object-action, #bool-controls input" ).each( function( index, element ){
			    $( this ).prop('disabled', true);
			});
		}
		disableBoolMenu();
		
		function enableBoolMenu() {
			$('#bool-controls').removeClass('hidden');
    		$( "#bool-controls .btn-object-action, #bool-controls input" ).each( function( index, element ){
			    $( this ).prop('disabled', false);
			});
		}

		
		function disableFontMenu() {
    		$( "#text-controls .btn-object-action" ).each( function( index, element ){
			    $( this ).prop('disabled', true);
			});
		}
		disableFontMenu();

		function enableFontMenu() {
			$('#text-controls').removeClass('hidden');
    		$( "#text-controls .btn-object-action" ).each( function( index, element ){
			    $( this ).prop('disabled', false);
			});
		}

		$("#text-line-height").change(function() {
			console.log("Change LineHeight");
		    canvas.getActiveObject().setLineHeight($('#text-line-height').val());
		    canvas.renderAll();

		});

		$("#text-font-size").change(function() {
			console.log("Change FontSize");
		    canvas.getActiveObject().set("fontSize", $('#text-font-size').val());
		    canvas.renderAll();
		    $('#fontSizeLabel').html($('#text-font-size').val());

		});


		$("#font-family").change(function() {
			console.log("Change FontFamily");
		    canvas.getActiveObject().setFontFamily($('#font-family').val());
		    canvas.renderAll();   

		});


		addToggleFunction2Button('text-cmd-bold','fontWeight','bold', 'normal');
		addToggleFunction2Button('text-cmd-italic','fontStyle ','italic', 'normal');
		addToggleFunction2ButtonTextDecoration('text-cmd-underline','underline', 'normal');
		addToggleFunction2ButtonTextDecoration('text-cmd-linethrough','line-through', 'normal');
		addToggleFunction2ButtonTextDecoration('text-cmd-overline','overline', 'normal');


		function addToggleFunction2ButtonTextDecoration(id, stateactive, stateelse){
			$("#" + id).click(function() {
				if($("#" + id).hasClass("active")){
					$("#" + id).removeClass("active");
		    		canvas.getActiveObject().setTextDecoration(stateelse);
				}else{
					$("#" + id).addClass("active");
		    		canvas.getActiveObject().setTextDecoration(stateactive); 	
				}
				canvas.renderAll();
				console.log("SetState (TextDecoration): " + canvas.getActiveObject().getTextDecoration());
			  
			});
		}

		function addToggleFunction2Button(id, fabricname, stateactive, stateelse){
			$("#" + id).click(function() {
				if($("#" + id).hasClass("active")){
					$("#" + id).removeClass("active");
		    		canvas.getActiveObject().set(fabricname, stateelse);
				}else{
					$("#" + id).addClass("active");
		    		canvas.getActiveObject().set(fabricname, stateactive); 	
				}
				canvas.renderAll();
				console.log("SetState (" + fabricname + "): " + canvas.getActiveObject().get(fabricname));
			  
			});
		}

		function initFontMenu(){
			size = canvas.getActiveObject().get("fontSize");
			$('#text-font-size').val(size);
		    $('#fontSizeLabel').html(size);


			lh = canvas.getActiveObject().getLineHeight();
			$('#text-line-height').val(lh);

			initButton('text-cmd-bold', 'fontWeight', 'bold');
			initButton('text-cmd-italic', 'fontStyle', 'italic');
			initButtonTextDecoration('text-cmd-underline', 'underline');
			initButtonTextDecoration('text-cmd-linethrough', 'line-through');
			initButtonTextDecoration('text-cmd-overline', 'overline');
			initFontFamily();
		}

		function initBoolMenu(){
			id = canvas.getActiveObject().get('id');
			hash = id.toString().replace("_j", "").replace("_n", "");
			console.log("Identified Bool-Element: Hash: " + hash);
			name = "";
			element_id = "";
			jQuery.each( constructElements, function( i, val ) {
				if(hash == val['hash']){
					name = val['varname'];
					element_id = i;
				}
			});
			console.log(constructElements[element_id]['type']);
			if(constructElements[element_id]['type'] == "checkbox"){
				$('#exampleDblBool').addClass('hidden');
			}else if(constructElements[element_id]['type'] == "bool"){
				$('#exampleDblBool').removeClass('hidden');
			}
			$('#boolVarname').val(name);
			
		}

		$('#boolVarname').on('input',function(e){
			id = canvas.getActiveObject().get('id');
			hash = id.toString().replace("_j", "").replace("_n", "");
			value = $('#boolVarname').val();
			jQuery.each( constructElements, function( i, val ) {
				if(hash == val['hash']){
					console.log("Changed Varname in BoolElement: " + hash + ": " + value);
					constructElements[i]['varname'] = value;
				}
			});

		});

		function initFontFamily(){
			state = canvas.getActiveObject().getFontFamily();
			$("select#font-family option").each(function() { this.selected = (this.value == state); });

		}

		function initButton(buttonID, fabricname, activename){
			state = canvas.getActiveObject().get(fabricname);
			if(state == activename){
				$("#" + buttonID).addClass("active");
			}else{
				$("#" + buttonID).removeClass("active");
			}
		}

		function initButtonTextDecoration(buttonID, activename){
			state = canvas.getActiveObject().getTextDecoration();
			if(state == activename){
				$("#" + buttonID).addClass("active");
			}else{
				$("#" + buttonID).removeClass("active");
			}
		}

		function randomHashCode(s){
		  return s.split("").reduce(function(a,b){a=((a<<5)-a)+b.charCodeAt(0);return a&a},0)*Math.floor(Math.random()*(100000-1)+0);             
		}


		function getCanvasObject(page, objectID){
			var exportcanvas = new fabric.Canvas();
    		exportcanvas.loadFromJSON(pages[page], exportcanvas.renderAll.bind(exportcanvas));
    		var obj = null;
			jQuery.each( exportcanvas.getObjects(), function( i, val ) {
				if(val.get('id') == objectID){
					console.log(val);
					obj = val;
				}
			});

			return obj;
		}

		function exportTextConstruction(cElement){
			object = getCanvasObject(cElement.page, cElement.hash);
			var element = {};

			element['page'] = cElement.page;
			element['type'] = 'text';
			element['fontFamily'] = object.get('fontFamily');
			element['fontWeight'] = object.get('fontWeight');
			element['fontSize'] = object.get('fontSize');
			element['fontStyle'] = object.get('fontStyle');
			element['top'] = object.get('top')/canvasHeight;
			element['left'] = object.get('left')/canvasWidth;
			element['width'] = object.get('width')/canvasWidth;
			element['height'] = object.get('height')/canvasHeight;
			element['text'] = "{{{" + object.get('text') + "}}}";
			element['textDecoration'] = object.getTextDecoration();
			element['id'] = object.get('id');

			return element;
		}

		function exportDblCheckboxConstruction(cElement){

			var obj_true = getCanvasObject(cElement.page, cElement.hash + "_j");
			var obj_false = getCanvasObject(cElement.page, cElement.hash + "_n");

			var elem_true = {};
			elem_true['top'] = obj_true.get('top')/canvasHeight;
			elem_true['left'] = obj_true.get('left')/canvasWidth;
			elem_true['width'] = obj_true.get('width')*obj_true.get('scaleX')/canvasWidth;
			elem_true['height'] = obj_true.get('height')*obj_true.get('scaleY')/canvasHeight;

			var elem_false = {};
			elem_false['top'] = obj_false.get('top')/canvasHeight;
			elem_false['left'] = obj_false.get('left')/canvasWidth;
			elem_false['width'] = obj_false.get('width')*obj_false.get('scaleX')/canvasWidth;
			elem_false['height'] = obj_false.get('height')*obj_false.get('scaleY')/canvasHeight;


			var element = {};
			element['page'] = cElement.page;
			element['type'] = 'dblCheckbox';

			element['elem_true'] = elem_true;
			element['elem_false'] = elem_false;

			element['id'] = cElement.hash;
			element['text'] = "{{{" + cElement.varname + "}}}";
			return element;
		}

		function exportCheckboxConstruction(cElement){
			object = getCanvasObject(cElement.page, cElement.hash);
			var element = {};

			element['page'] = cElement.page;
			element['type'] = 'checkbox';
			element['top'] = object.get('top')/canvasHeight;
			element['left'] = object.get('left')/canvasWidth;
			element['width'] = object.get('width')*object.get('scaleX')/canvasWidth;
			element['height'] = object.get('height')*object.get('scaleY')/canvasWidth;
			element['id'] = object.get('id');
			element['text'] = "{{{" + cElement.varname + "}}}";
			return element;
		}

		function generateExport(){
			pages[actPage] = canvas.toJSON(['id']);
			var elements = [];


			jQuery.each( constructElements, function( j, elem ) {
				console.log(elem);
					switch(elem.type) {
					    case 'text':
					        elements.push(exportTextConstruction(elem));
					        break;
					    case 'bool':
					        elements.push(exportDblCheckboxConstruction(elem));
					        break;
					    case 'checkbox':
					        elements.push(exportCheckboxConstruction(elem));
					        break;
					    default:
					        console.log("Unkown Type in Export");
					}
			});


			var exporttext = '<smwpdfexport template="##url##">\n';
			exporttext += '[\n';
			$.each(elements, function( k, v ) {
				
				exporttext += JSON.stringify(v, null, 2);
				
				if(k < elements.length-1){
					exporttext += ",\n";
				}
			});
			exporttext += '\n]\n';
			exporttext += '</smwpdfexport>';



			$("#text-controls").addClass('hidden');
			$("#TfExport").val(exporttext);
		}



		</script>	
	</body>		
</html>