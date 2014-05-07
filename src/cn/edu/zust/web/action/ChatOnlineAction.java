package cn.edu.zust.web.action;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.MappingDispatchAction;
import org.springframework.context.ApplicationContext;

import cn.edu.zust.biz.InterestGroupBiz;
import cn.edu.zust.entity.InterestGroup;
import cn.edu.zust.entity.User;

public class ChatOnlineAction extends MappingDispatchAction {
	private InterestGroupBiz interestGroupBiz;

	public InterestGroupBiz getInterestGroupBiz() {
		return interestGroupBiz;
	}

	public void setInterestGroupBiz(InterestGroupBiz interestGroupBiz) {
		this.interestGroupBiz = interestGroupBiz;
	}

	@SuppressWarnings("unchecked")
	public ActionForward checkUser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// ��session�еõ���ǰ�û�
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		PrintWriter out = response.getWriter();
		if (user == null) {
			out.print("loginError");
			return null;
		}
		// �Ӳ����еõ����û�Ҫ�������ȤС��
		String interestGroupId = request.getParameter("interestGroupId");
		//�жϸ��û��Ƿ�Ϊ����ȤС���Ա
		ApplicationContext ac = (ApplicationContext) request
		.getSession()
		.getServletContext()
		.getAttribute(
				"org.springframework.web.context.WebApplicationContext.ROOT");
		InterestGroupBiz igBiz=(InterestGroupBiz)ac.getBean("interestGroupBiz");
		InterestGroup ig=igBiz.query(Integer.valueOf(interestGroupId));
		System.out.println(ig.getUsers().size());
		
		Set<User> us=ig.getUsers();
		boolean b=false;
		for(User u:us){
			System.out.println(u.getId()+u.getLoginName());
			if(u.getId().equals(user.getId())){
				b=true;
				break;
			}
		}
		if (b == false) {
			out.print("notJiaRuError");
			return null;
		} 
		
		String loginName = user.getLoginName();
		// System.out.print("����û��������:"+name);

		// �õ�application
		ServletContext application = request.getSession().getServletContext();
		// ��application��ȡ�������ѵ�¼�ߵ���Ϣ
		Map<String, ArrayList<String>> users = (HashMap<String, ArrayList<String>>) application
				.getAttribute("users");
		// �����Ϣ�ǿգ��򴴽�
		if (users == null) {
			users = new HashMap<String, ArrayList<String>>();
		}
		
		// �õ���С�����Ϣ��С����ϢΪ��ʱ����
		List<String> list = users.get(interestGroupId);
		if (list == null) {
			list = new ArrayList<String>();
		}
		b = false;
		// �����Ϊ�վ͵��жϸ��û��Ƿ����
		if (list != null) {
			for (String string : list) {
				if (string.equals(loginName)) {
					b = true;
					break;
				}
			}
		}
		if (b == true) {
			out.print("loginedError");
			return null;
		} else {
			request.setAttribute("interestGroupId", interestGroupId);
			return this.doLogin(mapping, form, request, response);
		}
	}

	// ��½
	@SuppressWarnings("unchecked")
	public ActionForward doLogin(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// ��ȡ��ȥ��С��
		String interestGroupId = (String) request
				.getAttribute("interestGroupId");
		// ��ȡ����
		String name = ((User) request.getSession().getAttribute("user"))
				.getLoginName();

		// ����� application��
		ServletContext application = request.getSession().getServletContext();
		Map<String, ArrayList<String>> users = (HashMap<String, ArrayList<String>>) application
				.getAttribute("users");
		// ���Ϊ�գ��򴴽�
		if (users == null) {
			users = new HashMap<String, ArrayList<String>>();
		}
		ArrayList<String> list = users.get(interestGroupId);
		// �ж��Ƿ�Ϊ��
		if (list == null) { // �������ҵĵ�һ���û�
			list = new ArrayList<String>();
		}
		// System.out.println("������ӵ���:"+name);
		// �����û�����������
		list.add(name);
		// ������������Map�����У�������applicationӦ����
		users.put(interestGroupId, list);
		application.setAttribute("users", users);
		// ��ѯ������Ϣ
		Map<String, ArrayList<String>> messages = (HashMap<String, ArrayList<String>>) application
				.getAttribute("messages");
		if (messages == null) {
			messages = new HashMap<String, ArrayList<String>>();
		}
		// �õ���ǰС���message
		ArrayList<String> messageList = messages.get(interestGroupId);
		// ���Ϊ���򴴽�
		if (messageList == null) {
			messageList = new ArrayList<String>();
		}
		// �������199�����ݾ�ɾ��50��
		if (messageList.size() > 199) {
			List<String> ms = messageList.subList(0, 50);
			messageList.removeAll(ms);
		}
		messageList.add("\n��ӭ����ӭ��������л�ӭ��" + name + " , ������ȤС����.....\n");
		messages.put(interestGroupId, messageList);
		application.setAttribute("messages", messages);
		// response.sendRedirect("chat/main.jsp");
		return null;
	}

	@SuppressWarnings("unchecked")
	public ActionForward doInput(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// �Ӳ����еõ����û�Ҫ�������ȤС��
		String interestGroupId = request.getParameter("interestGroupId");
		// ��ȡ��ǰ�û�
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		if(user==null){
			return null;
		}
		String loginName = user.getLoginName();
		// ��ȡ���û����͵���Ϣ
		String message = request.getParameter("message");
		// message=new String(message.getBytes("GB2312"),"UTF-8");
		System.out.println(message);
		// ��������û����͵���Ϣ
		ServletContext application = request.getSession().getServletContext();
		Map<String, ArrayList<String>> messages = (HashMap<String, ArrayList<String>>) application
				.getAttribute("messages");
		// ���Ϊ���򴴽�
		if (messages == null) {
			messages = new HashMap<String, ArrayList<String>>();
		}
		// �õ���ǰС���message
		ArrayList<String> messageList = messages.get(interestGroupId);
		// ���Ϊ���򴴽�
		if (messageList == null) {
			messageList = new ArrayList<String>();
		}
		// �������199�����ݾ�ɾ��50��
		if (messageList.size() > 199) {
			List<String> ms = messageList.subList(0, 50);
			messageList.removeAll(ms);
		}
		// �������������Ϣ���ǿյģ��ͼ�����Ϣ
		if (message != null && !"".equals(message.trim())) {
			// message = URLDecoder.decode(message, "GB2312");
			message = loginName
					+ "  ("
					+ new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
							.format(new Date()) + ")  ˵:\n" + message + "\n";

			// ��ӵ�������
			messageList.add(message);
			// ��ӵ�application������
			messages.put(interestGroupId, messageList);
			application.setAttribute("messages", messages);
		}
		StringBuffer buffer = new StringBuffer("Welcome to Chatting Room\n");
		if (messageList != null && messageList.size() != 0) {
			for (String string : messageList) {
				buffer.append(string);
			}
		}
		// ���
		PrintWriter out = response.getWriter();
		out.print(buffer.toString());
		out.close();
		return null;
	}

	@SuppressWarnings("unchecked")
	public ActionForward doLayout(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// ����С��id
		String interestGroupId = request.getParameter("interestGroupId");
		HttpSession session = request.getSession();
		// �õ���ǰ�û�
		User user = (User) session.getAttribute("user");
		if (user == null) {
			return null;
		}
		String loginName = user.getLoginName();
		// ������ȤС����û�
		ServletContext application = request.getSession().getServletContext();
		Map<String, ArrayList<String>> users = (HashMap<String, ArrayList<String>>) application
				.getAttribute("users");

		if (users != null) {
			ArrayList<String> list = users.get(interestGroupId);
			System.out.println("С���Ա������" + list.size());
			// �����û�ɾ��
			list.remove(loginName);
			users.put(interestGroupId, list);
			application.setAttribute("users", users);
			System.out.println("С���Ա������" + list.size());
		}

		// ��ѯ����С�����Ϣ
		Map<String, ArrayList<String>> messages = (HashMap<String, ArrayList<String>>) application
				.getAttribute("messages");
		if (messages == null) {
			messages = new HashMap<String, ArrayList<String>>();
		}
		ArrayList<String> messageList = messages.get(interestGroupId);
		if (messageList == null) {
			messageList = new ArrayList<String>();
		}
		messageList.add("\n" + loginName + " , �뿪��������.....\n");
		messages.put(interestGroupId, messageList);
		application.setAttribute("messages", messages);
		// response.sendRedirect("/achat/chat/index.jsp");
		return null;
	}

	@SuppressWarnings("unchecked")
	public ActionForward getUser(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		// ��application��ȡ�������ѵ�¼�ߵ���Ϣ
		// ����� application��
		ServletContext application = request.getSession().getServletContext();
		Map<String, ArrayList<String>> users = (Map<String, ArrayList<String>>) application
				.getAttribute("users");
		// ���С����
		String interestGroupId = request.getParameter("interestGroupId");
		ArrayList<String> list = users.get(interestGroupId);
		int size = 0;
		if (list != null)
			size = list.size();
		// ���С�������
		int total = 0;
		InterestGroup ig = interestGroupBiz.query(Integer
				.valueOf(interestGroupId));
		if (ig != null && ig.getUsers() != null) {
			total = ig.getUsers().size();
		}
		StringBuffer buffer = new StringBuffer("С���Ա(" + size + "/" + total
				+ ")\n");
		if (list != null) {
			for (String string : list) {
				buffer.append("<font color='red'>" + string + "</font>" + "\n");
			}
		}
		Set<User> us = ig.getUsers();
		List<String> listUs = new ArrayList<String>();
		for (User u : us) {
			listUs.add(u.getLoginName());
		}
		listUs.removeAll(list);
		for (String lu : listUs) {
			buffer.append(lu + "\n");
		}
		// ���������Ϣ�ĸ�ʽ���ַ���
		response.setContentType("text/xml; charset=GB2312");
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter out = response.getWriter();
		out.print("<response>");
		out.print("<userinfo>");
		out.print(buffer.toString());
		out.print("</userinfo>");
		out.print("</response>");
		return null;
	}

	@SuppressWarnings("unchecked")
	public ActionForward chat(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String interestGroupId = request.getParameter("interestGroupId");
		InterestGroup ig = interestGroupBiz.query(Integer
				.valueOf(interestGroupId));
		request.setAttribute("chatIg", ig);
		request.setAttribute("interestGroupId", interestGroupId);

		// ��������û����͵���Ϣ
		ServletContext application = request.getSession().getServletContext();
		Map<String, ArrayList<String>> messages = (HashMap<String, ArrayList<String>>) application
				.getAttribute("messages");
		// ���Ϊ���򴴽�
		if (messages == null) {
			messages = new HashMap<String, ArrayList<String>>();
		}
		// �õ���ǰС���message
		ArrayList<String> messageList = messages.get(interestGroupId);
		// ���Ϊ���򴴽�
		if (messageList == null) {
			messageList = new ArrayList<String>();
		}
		// �������199�����ݾ�ɾ��50��
		if (messageList.size() > 199) {
			List<String> ms = messageList.subList(0, 50);
			messageList.removeAll(ms);
		}
		StringBuffer buffer = new StringBuffer("Welcome to Chatting Room\n");
		if (messageList != null && messageList.size() != 0) {
			for (String string : messageList) {
				buffer.append(string);
			}
		}
		request.setAttribute("messageList", buffer.toString());
		return mapping.findForward("success");
	}
}
