<%@ page language="java" pageEncoding="GB2312"%>
<html>
	<head>
		<title>XX��ȤС��������</title>
		<link rel="stylesheet" type="text/css"
			href="${pageContext.request.contextPath }/css/styles.css">
		<style type="text/css">
#contentDiv {
	background-color: #dd9a22;
	font-size: 11px;
}

body {
	font-size: 11px;
	background-color: #eeeeee;
}

a {
	font-size: 12px;
	color: blue;
	text-decoration: none;
}

a:hover {
	font-size: 12px;
	color: green;
	text-decoration: underline;
}

#chatDiv {
	border: 1px solid #eeeeee;
	float: left;
	width: 470px;
	margin: 3px;
	color: blue;
	background-color: #eeeeee;
}

#userDiv {
	border: 0px solid black;
	float: left;
	width: 117px;
	height: 440px;
	margin-top: 3px;
	line-height: 18px;
	text-decoration: underline;
	padding-left: 5px;
}
</style>
		<script language="javascript">
			window.onunload = closeWindow;
			
			function closeWindow(){
					clearUser();
			}
			
			function clearUser(){
				var url = "${pageContext.request.contextPath}/doLayout.do";
				xmlRequest = createXMLHttpRequest(); //��������
				//״̬�ı�
				xmlRequest.onreadystatechange = clearStatus;
				xmlRequest.open("GET",url,true);
				xmlRequest.send(null);  // ��������
				window.close();
			}
			
			//�ص�����
			function clearStatus(){
				if(xmlRequest.readyState==4){
					if(xmlRequest.status ==200) {
						//alert("�˳��ɹ���");
					}else{
						alert(xmlRequest.status);
					}
				}
			}
		
			//����XMLHttpRequest����
			var xmlRequest;
			
			//��������
			function createXMLHttpRequest(){
				if(window.XMLHttpRequest) { //Mozilla �����
					return new XMLHttpRequest();
				}else if (window.ActiveXObject) { // IE�����
					try {
						return new ActiveXObject("Msxml2.XMLHTTP");
					} catch (e) {
						try {
							return new ActiveXObject("Microsoft.XMLHTTP");
						} catch (e) {}
					}
				}
			}
			
			//��ʾ��Ϣ
			function showMess(value,color){
				document.getElementById("divMess").innerHTML="<font color='"+color+"'>"+value+"</font>";
			}
			
			
			//����������Ϣ
			function sendMessage(){
				var objMessage = document.getElementById("message");
				if(objMessage.value==""){
					showMess("���ݲ���Ϊ�գ�","red");
					objMessage.focus();
					return;
				}
				
				for(var i=0;i<objMessage.value.length;i++){
						var ch = objMessage.value.charAt(i);
						if(ch=='<' || ch =='>' || ch=='-' || ch=='/' || ch=='\\'){
							objMessage.focus();
							showMess("���ܺ���<,>,-�������ַ���","red");
							return;
						}
				}
				
				if(objMessage.value.length>100){
					showMess("100�����ڣ�","red");
					objMessage.focus();
					return;
				}
				//���� doinput ���������������
				var url = "${pageContext.request.contextPath}/doInput.do?message="+objMessage.value;
				document.getElementById("message").value="";
				sendRequest(url);
				
			}
			//����������
			function sendRequest(url){
				xmlRequest = createXMLHttpRequest(); //��������
				url=encodeURI(url); 
				url=encodeURI(url); 
				//״̬�ı�
				xmlRequest.onreadystatechange = dataChanged;
				xmlRequest.open("POST",url,true);
				xmlRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
				xmlRequest.send(url);  // ��������
			}
			
			//��Ӧ�ĺ���
			function dataChanged(){
				if(xmlRequest.readyState==4){
					if(xmlRequest.status ==200) {
						//��Ϣ�Ѿ��ɹ�����
						showChatMessage();
					}else{
						showMess("���������ҳ�����쳣��");
					}
				}
			}
			
			function showChatMessage(){
				var message = xmlRequest.responseXML.getElementsByTagName("message")[0].firstChild.nodeValue;
				document.frames("chat").document.body.innerText = message;
			}
			
			//ÿ�������Ӳ�ѯһ��
			window.setInterval("sendRequest('${pageContext.request.contextPath}/doInput.do')",300);
			var id ;
			function setAuto(){
				id = setInterval("document.frames('chat').document.body.scrollTop=document.frames('chat').document.body.scrollHeight",300);
			}
			function clearAuto(){
				clearInterval(id);
			}
		</script>

	</head>
	<body
		onload="sendRequest('${pageContext.request.contextPath}/doInput.do');setAuto();window.status='��ʾ:����������ע�����۹���!'">
		<div id="contentDiv">
			<div id="titleDiv">
				<marquee direction="left" scrolldelay="200">${sessionuser }..��ӭ����XXX��ȤС��������..o(��_��)o..
				</marquee>
			</div>
			<div id="chatDiv">
				<iframe src="chat.jsp" name="chat" frameborder="1" scrolling="auto"
					height="350px" width="470px">
				</iframe>
				<span id="divMess" style="width: 240px;">����������(100������)! </span>
				<div style="display: inline; text-align: right; width: 200px">
					<a href="javascript:setAuto()">�Զ�����</a>&nbsp;
					<a href="javascript:clearAuto()">ȡ������</a> &nbsp;
					<a href="${pageContext.request.contextPath}/doLayout.do">�˳�</a>
				</div>
				<div>
					<textarea rows="3" cols="56" id="message"></textarea>
				</div>
				<div style="text-align: right; padding-right: 0px;">
					<input type="button" value="ȷ��" class="longBtn"
						onclick="sendMessage()">
				</div>
			</div>
			<div id="userDiv">
				<iframe src="user.jsp" name="userframe" frameborder="1"
					scrolling="auto" height="440px" width="110px">
				</iframe>
			</div>
		</div>
	</body>
</html>