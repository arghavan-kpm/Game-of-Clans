package controller;

import domain.Connect2DB;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class signupCtrl extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connect2DB c2d = new Connect2DB();
        try{
            Connection con = c2d.connect2DB();
            String user = request.getParameter("user");
            String pass = request.getParameter("pass");

            CallableStatement cs = null;
            cs = con.prepareCall("{? = call isUserAlreadyExist(?)}");
            int ind = 0;
            cs.registerOutParameter(++ind, Types.INTEGER);
            cs.setString(++ind,user);
            cs.execute();

            int res = cs.getInt(1);
            if(res == 1){       //user already exist
                request.setAttribute("msg" , "User already exist");
                request.getRequestDispatcher("index.jsp").forward(request, response);

            }
            else{       // user signed up

                cs = null;
                cs = con.prepareCall("{call addUserToGame(?,?)}");
                ind = 0;
                cs.setString(++ind,user);
                cs.setString(++ind,pass);

                cs.execute();

                request.setAttribute("user" , user);
                request.getRequestDispatcher("chooseClan.jsp").forward(request, response);
            }

        }catch (Exception e){
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }

    }
}
