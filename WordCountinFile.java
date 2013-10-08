import java.io.*;
import java.util.*;

class WordCountFile{
    public static void main(String args[]) throws Exception{
        Console con  = System.console();
        
        String str;
        
        HashMap map = new HashMap();
        HshSet set = new HashSet();
        
        System.out.print("Enter file name: ");
        
        str = con.readLine();
        
        FileInputStream fs = new FileInputStream(str);
        
        int ch;
        String newstr;
        
        while ((ch = fs.read())!=-1){
            newstr += (char)ch+"" 
        }
        
        StringTokenizer st = new String Tokenizer(newstr);
        
        while(st.hasMoreTokens()){
            String s = st.nextToken();
            map.puti(i+"", s);
            set.add(s);
            i++;
        }
        
        Iterator itr = set.Iterator();
        
        System.out.println("Ocuuraance and words: ");
        
        while(itr.hasNext()){
            String str1;
            int count=0;
            
            str1= (String)itr.next();
            
            for(int j=0; j<i; j++){
                String str2;
                str2  = (String)map.get(j+"");
                if (str1.equals(str2)){
                        count++;
                }
            }
            System.out.println("%10s %10d\n", str1, count);
        }
        System.out.println("Total number of words are: "+ i);
    }

}