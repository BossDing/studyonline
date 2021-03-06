<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<link rel="stylesheet" type="text/css"
			href="${pageContext.request.contextPath }/kindeditor-3.4/skins/oxygen.css" />
		<script type="text/javascript" charset="utf-8"
			src="${pageContext.request.contextPath }/kindeditor-3.4/kindeditor.js"></script>
		<link href="${pageContext.request.contextPath }/css/css.css"
			rel="stylesheet" type="text/css"></link>
		<script type='text/javascript'
			src='${pageContext.request.contextPath }/dwr/interface/QualificationTypeDwr.js'></script>
		<script type='text/javascript'
			src='${pageContext.request.contextPath }/dwr/engine.js'></script>
		<script type='text/javascript'
			src='${pageContext.request.contextPath }/dwr/util.js'></script>
		<script type="text/javascript">
			window.onload=function(){
				QualificationTypeDwr.query(function(qualificationTypes){
					dwr.util.removeAllOptions("qualificationTypes");
					dwr.util.addOptions("qualificationTypes",qualificationTypes);
				});
			}
			KE.show({
				id : 'content',
				autoOnsubmitMode : false, //不会自动把KE.util.setData添加到onsubmit事件里。
				loadStyleMode : false, //不会自动加载CSS文件。
				cssPath : './index.css'
			});
			function checkForm() {
				var title=document.getElementById("title").value;
				if(title==""||title==null){
					alert("请输入标题!");
					return false;
				}
				var data = KE.util.getPureData('content').replace(/\r\n|\n|\r/, '').replace(/^\s+|\s+$/, '');
				if (data.length == 0) {
					alert('请输入内容！');
					return false;
				}
				KE.util.setData('content');
				return true;
			}
		</script>
	</head>
	<body>
		<form method="post" onsubmit="javascript:return checkForm();"
			action="${pageContext.request.contextPath }/admin/addAccreditation.do">
			<table class="table" cellspacing="1" cellpadding="2" width="99%"
				align="center" border="0">
				<tr>
					<td>
						标题：
					</td>
					<td colspan="3">
						<input type="text" name="title" id="title" size="80" />
					</td>
				</tr>
				<tr height="30">
					<td width="25%">
						所属类别：
					</td>
					<td colspan="3">
						<select name="qualificationType" id="qualificationTypes"></select>
					</td>
				</tr>
				<tr height="30">
					<td colspan="4">
						动态内容：
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<div class="editor">
							<textarea id="content" name="content"
								style="width: 100%; height: 300px;"></textarea>
						</div>
					</td>
				</tr>
			</table>
			<table cellspacing="0" cellpadding="0" width="60%" align="center"
				border="0">
				<tr height="30" align="center">
					<td>
						<input type="submit" value="提交" id="tiJiao">
					</td>
					<td>
						<input type="reset" value="重置">
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
