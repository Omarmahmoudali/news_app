import 'package:flutter/material.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/web_view/web_view_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

Widget defaultButton({
  bool isUpperCase = true,
  double? width = double.infinity,
  Color? color = Colors.blue,
  double radius = 10.0,
  required Function onPressed,
  required String text,
}) =>
    Container(
      height: 40.0,
      width: width,
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
    );

Widget defaultTextButton({
  required Function onPressed,
  required String text,
})=>TextButton(
  onPressed: (){
  onPressed();
},
  child: Text(text),);

Widget defaultFormField({
  required TextEditingController? controller,
  required TextInputType type,
  Function(String val)?onFieldSubmitted,
  Function(String val)? onChanged,
  Function()? onTap,
  required String? Function(String? value)? validator,
  required String labelText,
  required IconData prefixIcon,
  IconData? suffixIcon,
  bool isPassword = false,
  Function? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      obscureText: isPassword,
      onFieldSubmitted: onFieldSubmitted ,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
        ),
        labelText: labelText,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffixIcon,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );



class CustomText extends StatelessWidget {
  final String text;
  final Color color;

  final double fontsize;

  CustomText({
    required this.text,
    required this.color,
    required this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontsize,
      ),
    );
  }
}

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey,
      ),
    );

Widget buildArticleItem(article,context)=> InkWell(
  onTap: ()
  {
    navigateTo(context, WebViewScreen(article['url']));
  },
  child:Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage('${article['urlToImage']}'),
                fit: BoxFit.cover,
              )),
        ),
        const SizedBox(width: 20.0,),
        Expanded(
          child: Container(
            height: 120.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${article['title']}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Text(
                  '${article['publishedAt']}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);

Widget articleBuilder(list,context,{isSearch= false})=> ConditionalBuilder(
  condition: list.length>0,
  builder: (context) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    itemBuilder: (context,index)=>buildArticleItem(list[index],context),
    separatorBuilder: (context,index)=>myDivider(),
    itemCount: list.length ,
  ),
  fallback: (context) => isSearch ? Container() :const Center(child: const CircularProgressIndicator()),
);

void navigateTo(context,widget)=>Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(context , widget)=> Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context)=>widget),
        (route) => false);

