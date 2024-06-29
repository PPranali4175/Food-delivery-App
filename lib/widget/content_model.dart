class UnboardingContent{
  String image;
  String title;
  String description;
  UnboardingContent({required this.description,required this.image,required this.title});
}
List<UnboardingContent> contents=[
  UnboardingContent(description: 'pick your food from our menu\n      more than 35 times', image: "images/img_2.png", title: 'select from our\n     Best menu '),
  UnboardingContent(description: 'you can pay cash on delievery and\n  card payment is available', image: "images/img_3.png", title: 'easy and online payment'),
  UnboardingContent(description: 'Deliever your food at your\n  door steps', image: "images/img_4.png", title: 'Quick delievery at your Doorstep')

];