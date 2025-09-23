// import 'package:flutter/material.dart';

// class Message {
//   final String text;
//   final bool isUser;
//   final DateTime timestamp;
//   final List<String>? options;

//   Message({
//     required this.text,
//     required this.isUser,
//     required this.timestamp,
//     this.options,
//   });
// }

// class QuestionFlow {
//   static const Map<String, Map<String, dynamic>> questionMap = {
//     // Main categories
//     'main': {
//       'message':
//           '🌿 Welcome to Ambrosia Ayurved Diabetes Support!\n\nI\'m here to help you with diabetes information. Please select what you\'d like to know about:',
//       'options': [
//         'What is Diabetes?',
//         'Types of Diabetes',
//         'Symptoms & Signs',
//         'Causes & Risk Factors',
//         'Diet & Nutrition',
//         'Exercise & Lifestyle',
//         'Management Tips',
//         'Our Ayurvedic Products'
//       ]
//     },

//     // What is diabetes
//     'What is Diabetes?': {
//       'message': '''**What is Diabetes? 🩺**

// Diabetes is a chronic condition that occurs when your blood glucose (blood sugar) is too high. It happens when:

// • Your body doesn't make enough insulin, OR
// • Your body can't use insulin properly, OR
// • Both

// **Key Facts:**
// • Insulin helps glucose enter your cells for energy
// • Without proper insulin function, glucose stays in blood
// • High blood glucose over time causes serious health problems
// • Early detection and management are crucial

// 🌿 **Good News:** With proper care and natural Ayurvedic support, diabetes can be managed effectively!''',
//       'options': [
//         'Types of Diabetes',
//         'Symptoms & Signs',
//         'How is it Diagnosed?',
//         'Can it be Prevented?',
//         'Our Natural Solutions',
//         '← Back to Main Menu'
//       ]
//     },

//     // Types of diabetes
//     'Types of Diabetes': {
//       'message': '''**Types of Diabetes 📋**

// **1. Type 1 Diabetes**
// • Body stops making insulin
// • Usually starts in childhood/young adults
// • Requires insulin injections
// • About 5-10% of all diabetes cases

// **2. Type 2 Diabetes**
// • Body doesn't use insulin well
// • Most common type (90-95%)
// • Often develops after age 45
// • Can often be managed with lifestyle changes

// **3. Gestational Diabetes**
// • Develops during pregnancy
// • Usually goes away after delivery
// • Increases risk of Type 2 later

// **4. Prediabetes**
// • Blood sugar higher than normal
// • Not high enough to be diabetes
// • Can be reversed with lifestyle changes''',
//       'options': [
//         'Type 1 Details',
//         'Type 2 Details',
//         'Gestational Diabetes Info',
//         'Prediabetes Information',
//         'Which Type Do I Have?',
//         '← Back to Main Menu'
//       ]
//     },

//     // Symptoms
//     'Symptoms & Signs': {
//       'message': '''**Diabetes Symptoms & Warning Signs ⚠️**

// **Common Early Symptoms:**
// • 🚰 Frequent urination (especially at night)
// • 🥤 Excessive thirst
// • 😴 Unusual fatigue and weakness
// • 📉 Unexplained weight loss
// • 🍽️ Increased hunger
// • 👁️ Blurred vision
// • 🩹 Slow healing cuts/bruises
// • 🦠 Frequent infections

// **Advanced Symptoms:**
// • Numbness in hands/feet
// • Dark skin patches (acanthosis nigricans)
// • Recurring skin infections
// • Sweet-smelling breath

// **⚠️ Emergency Signs:**
// • Extreme thirst and frequent urination
// • Nausea and vomiting
// • Deep, rapid breathing
// • Confusion or unconsciousness''',
//       'options': [
//         'Early vs Late Symptoms',
//         'Type 1 vs Type 2 Symptoms',
//         'When to See a Doctor?',
//         'How to Monitor Symptoms',
//         'Natural Symptom Management',
//         '← Back to Main Menu'
//       ]
//     },

//     // Causes & Risk Factors
//     'Causes & Risk Factors': {
//       'message': '''**Diabetes Causes & Risk Factors 🎯**

// **Type 1 Causes:**
// • Autoimmune reaction destroys insulin cells
// • Genetic factors
// • Environmental triggers (viruses, stress)
// • Family history

// **Type 2 Risk Factors:**
// • **Age:** 45+ years
// • **Weight:** Overweight/obesity
// • **Family History:** Parents/siblings with diabetes
// • **Lifestyle:** Sedentary lifestyle, poor diet
// • **Medical:** High blood pressure, abnormal cholesterol
// • **Ethnicity:** Higher risk in certain groups

// **Gestational Risk Factors:**
// • Age over 25
// • Previous gestational diabetes
// • Family history of diabetes
// • Overweight before pregnancy

// **🌿 Ayurvedic Perspective:**
// According to Ayurveda, diabetes (Prameha) occurs due to imbalanced doshas, poor digestion, and lifestyle factors.''',
//       'options': [
//         'Can I Prevent Type 2?',
//         'Genetic vs Lifestyle Factors',
//         'Ayurvedic Understanding',
//         'Risk Assessment',
//         'Prevention Strategies',
//         '← Back to Main Menu'
//       ]
//     },

//     // Diet & Nutrition
//     'Diet & Nutrition': {
//       'message': '''**Diabetes Diet & Nutrition Guide 🥗**

// **Best Foods for Diabetes:**
// • **Vegetables:** Non-starchy (spinach, broccoli, peppers)
// • **Proteins:** Lean meats, fish, eggs, legumes
// • **Whole Grains:** Brown rice, oats, quinoa
// • **Healthy Fats:** Nuts, olive oil, avocados
// • **Low-GI Fruits:** Berries, apples, citrus

// **Foods to Limit:**
// • Refined sugars and sweets
// • White bread, rice, pasta
// • Sugary drinks and sodas
// • Processed and fried foods
// • High-sodium foods

// **Ayurvedic Diet Tips:**
// • Eat warm, cooked foods
// • Include bitter and astringent tastes
// • Avoid cold drinks with meals
// • Eat largest meal at midday
// • Include spices like turmeric, cinnamon''',
//       'options': [
//         'Meal Planning Tips',
//         'Carb Counting Basics',
//         'Ayurvedic Food Guidelines',
//         'Snack Ideas',
//         'Foods to Avoid Completely',
//         '← Back to Main Menu'
//       ]
//     },

//     // Exercise & Lifestyle
//     'Exercise & Lifestyle': {
//       'message': '''**Exercise & Lifestyle for Diabetes 🏃‍♂️**

// **Exercise Benefits:**
// • Lowers blood glucose naturally
// • Increases insulin sensitivity
// • Helps with weight management
// • Reduces cardiovascular risk
// • Improves mood and energy

// **Recommended Activities:**
// • **Aerobic:** 150 min/week moderate intensity
//   - Brisk walking, swimming, cycling
// • **Strength Training:** 2+ days/week
//   - Weight lifting, resistance bands
// • **Flexibility:** Yoga, stretching daily

// **Lifestyle Changes:**
// • Maintain regular sleep schedule (7-8 hours)
// • Manage stress through meditation/yoga
// • Quit smoking completely
// • Limit alcohol consumption
// • Stay hydrated (8-10 glasses water/day)

// **🌿 Ayurvedic Lifestyle:**
// • Practice pranayama (breathing exercises)
// • Follow daily routine (dinacharya)
// • Include morning sun exposure''',
//       'options': [
//         'Exercise Safety Tips',
//         'Yoga for Diabetes',
//         'Stress Management',
//         'Sleep & Diabetes',
//         'Ayurvedic Daily Routine',
//         '← Back to Main Menu'
//       ]
//     },

//     // Management Tips
//     'Management Tips': {
//       'message': '''**Diabetes Management Tips 📊**

// **Daily Management:**
// • Monitor blood sugar as recommended
// • Take medications on time
// • Follow consistent meal schedule
// • Stay physically active
// • Keep emergency supplies ready

// **Long-term Care:**
// • Regular doctor checkups
// • Annual eye and foot exams
// • Dental care every 6 months
// • Blood pressure monitoring
// • Cholesterol level checks

// **Self-Care Essentials:**
// • Learn to recognize low/high blood sugar
// • Keep glucose tablets handy
// • Maintain diabetes diary
// • Stay informed about condition
// • Build strong support system

// **🌿 Ayurvedic Management:**
// • Take herbs like bitter gourd, fenugreek
// • Practice oil pulling (oil in mouth)
// • Follow seasonal routines
// • Use natural blood purifiers
// • Regular panchakarma treatments''',
//       'options': [
//         'Blood Sugar Monitoring',
//         'Medication Management',
//         'Emergency Preparedness',
//         'Ayurvedic Daily Practices',
//         'When to Call Doctor',
//         '← Back to Main Menu'
//       ]
//     },

//     // Products
//     'Our Ayurvedic Products': {
//       'message': '''🌿 **Ambrosia Ayurved Diabetes Care Products**

// **🍃 Sugar Shield Plus** - ₹1,299
// • Natural blood glucose support
// • Contains Gymnema, Bitter Gourd, Methi
// • Helps reduce sugar cravings

// **🍃 Diabetic Care Formula** - ₹1,599
// • Comprehensive diabetes management
// • Supports pancreatic function
// • Improves insulin sensitivity

// **🍃 Herbal Insulin Support** - ₹1,199
// • Ayurvedic insulin sensitivity booster
// • Contains Vijaysar, Karela, Jamun
// • Helps in glucose metabolism

// **🍃 Pancreas Wellness** - ₹1,399
// • Supports pancreatic health
// • Natural beta cell protection
// • Digestive enzyme support

// **✨ Why Choose Ambrosia Ayurved?**
// • 100% Natural ingredients
// • Clinically tested formulations
// • No harmful side effects
// • Trusted by 50,000+ customers''',
//       'options': [
//         'Product Details & Benefits',
//         'Pricing & Offers',
//         'How to Use Products',
//         'Customer Reviews',
//         'Order Now',
//         '← Back to Main Menu'
//       ]
//     },

//     // Follow-up questions for deeper information
//     'Type 1 Details': {
//       'message': '''**Type 1 Diabetes - Detailed Information 🎯**

// **What Happens:**
// • Immune system attacks insulin-producing beta cells
// • Pancreas makes little to no insulin
// • Glucose can't enter cells, stays in blood
// • Usually develops quickly over weeks/months

// **Who Gets It:**
// • Often children, teens, young adults
// • Can occur at any age
// • Family history increases risk slightly
// • More common in people of European descent

// **Management:**
// • Daily insulin injections/pump required
// • Frequent blood glucose monitoring
// • Carbohydrate counting essential
// • Regular medical care crucial

// **🌿 Ayurvedic Support:**
// While insulin is essential, Ayurvedic herbs can help:
// • Improve overall health and immunity
// • Support digestive function
// • Reduce inflammation
// • Enhance quality of life''',
//       'options': [
//         'Insulin Types & Timing',
//         'Carb Counting for Type 1',
//         'Ayurvedic Support for Type 1',
//         'Living with Type 1',
//         'Our Supportive Products',
//         '← Back to Types Menu'
//       ]
//     },

//     'Type 2 Details': {
//       'message': '''**Type 2 Diabetes - Detailed Information 📈**

// **What Happens:**
// • Body becomes resistant to insulin
// • Pancreas can't make enough insulin
// • Develops gradually over years
// • Often goes undiagnosed initially

// **Risk Factors:**
// • Age 45+ (but increasing in younger people)
// • Overweight/obesity (especially belly fat)
// • Sedentary lifestyle
// • Family history
// • High blood pressure
// • Abnormal cholesterol levels

// **The Good News:**
// • Can often be managed without insulin initially
// • Lifestyle changes can be very effective
// • May be prevented or delayed
// • Natural approaches work well

// **🌿 Ayurvedic Excellence:**
// Type 2 responds exceptionally well to Ayurvedic treatment:
// • Herbs that improve insulin sensitivity
// • Natural compounds that reduce glucose absorption
// • Lifestyle practices that balance metabolism''',
//       'options': [
//         'Lifestyle Management',
//         'Medication Options',
//         'Ayurvedic Treatment Approach',
//         'Prevention Strategies',
//         'Our Specialized Products',
//         '← Back to Types Menu'
//       ]
//     },

//     // Contact flow
//     'contact': {
//       'message': '''📞 **Need More Information?**

// For personalized guidance and expert consultation about diabetes management and our Ayurvedic products:

// **Call Our Diabetes Care Experts:**
// 📱 **Phone: +91-8000057233**

// **📋 Our Experts Can Help With:**
// • Personalized product recommendations
// • Dosage and usage guidance
// • Diet and lifestyle counseling
// • Product ordering and delivery
// • Follow-up support

// **🕒 Available:**
// Monday - Saturday: 9:00 AM - 7:00 PM
// Sunday: 10:00 AM - 5:00 PM

// **💬 What to Expect:**
// • Free 15-minute consultation
// • Customized diabetes care plan
// • Product recommendations based on your needs
// • Ongoing support throughout your journey

// 🌿 **Take the first step towards natural diabetes management today!**''',
//       'options': ['Call Now: +91-8000057233', '← Back to Main Menu']
//     }
//   };

//   static List<String> getFollowUpOptions(String question) {
//     return questionMap[question]?['options']?.cast<String>() ?? [];
//   }

//   static String getResponse(String question) {
//     return questionMap[question]?['message'] ??
//         'I apologize, but I don\'t have information about that topic. Please contact our experts at +91-8000057233 for personalized assistance.';
//   }
// }

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final ScrollController _scrollController = ScrollController();
//   List<Message> messages = [];
//   int questionCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _startConversation();
//   }

//   void _startConversation() {
//     messages.add(Message(
//       text: QuestionFlow.getResponse('main'),
//       isUser: false,
//       timestamp: DateTime.now(),
//       options: QuestionFlow.getFollowUpOptions('main'),
//     ));
//   }

//   void _handleOptionSelected(String option) {
//     // Add user's selection
//     setState(() {
//       messages.add(Message(
//         text: option,
//         isUser: true,
//         timestamp: DateTime.now(),
//       ));
//       questionCount++;
//     });

//     _scrollToBottom();

//     // Handle special cases
//     if (option == '← Back to Main Menu') {
//       _addBotResponse('main');
//       return;
//     }

//     if (option == '← Back to Types Menu') {
//       _addBotResponse('Types of Diabetes');
//       return;
//     }

//     if (option.startsWith('Call Now:')) {
//       _addBotResponse('contact');
//       return;
//     }

//     // Add bot response after delay
//     Future.delayed(Duration(milliseconds: 800), () {
//       _addBotResponse(option);
//     });
//   }

//   void _addBotResponse(String questionKey) {
//     String response = QuestionFlow.getResponse(questionKey);
//     List<String> options = QuestionFlow.getFollowUpOptions(questionKey);

//     // After answering 3-4 questions, show contact message
//     if (questionCount >= 3 &&
//         questionKey != 'main' &&
//         questionKey != 'contact' &&
//         !questionKey.contains('←')) {
//       response +=
//           '\n\n📞 **Need personalized guidance?** Contact our diabetes care experts at +91-8000057233 for customized advice and product recommendations!';
//     }

//     // If no specific options, provide contact option
//     if (options.isEmpty && questionKey != 'main') {
//       options = ['Contact Our Experts', '← Back to Main Menu'];
//     }

//     // Handle contact option
//     if (questionKey == 'Contact Our Experts') {
//       response = QuestionFlow.getResponse('contact');
//       options = QuestionFlow.getFollowUpOptions('contact');
//     }

//     setState(() {
//       messages.add(Message(
//         text: response,
//         isUser: false,
//         timestamp: DateTime.now(),
//         options: options,
//       ));
//     });

//     _scrollToBottom();
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent + 100,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Icon(Icons.local_hospital, color: Colors.white),
//             SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 'Ambrosia Diabetes Care',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green[700],
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.phone, color: Colors.white),
//             onPressed: () => _handleOptionSelected('Contact Our Experts'),
//             tooltip: 'Contact Us',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Chat messages
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: EdgeInsets.all(16),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return _buildMessageBubble(messages[index]);
//               },
//             ),
//           ),

//           // Footer
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               border: Border(
//                 top: BorderSide(color: Colors.green[200]!),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.phone, color: Colors.green[700], size: 16),
//                 SizedBox(width: 4),
//                 Text(
//                   'Need help? Call +91-8000057233',
//                   style: TextStyle(
//                     color: Colors.green[700],
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Message message) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6),
//       child: Column(
//         crossAxisAlignment:
//             message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           // Message bubble
//           Row(
//             mainAxisAlignment: message.isUser
//                 ? MainAxisAlignment.end
//                 : MainAxisAlignment.start,
//             children: [
//               if (!message.isUser) ...[
//                 CircleAvatar(
//                   backgroundColor: Colors.green[700],
//                   child:
//                       Icon(Icons.local_hospital, color: Colors.white, size: 18),
//                   radius: 16,
//                 ),
//                 SizedBox(width: 8),
//               ],
//               Flexible(
//                 child: Container(
//                   padding: EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color:
//                         message.isUser ? Colors.green[700] : Colors.grey[100],
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     message.text,
//                     style: TextStyle(
//                       color: message.isUser ? Colors.white : Colors.black87,
//                       fontSize: 14,
//                       height: 1.4,
//                     ),
//                   ),
//                 ),
//               ),
//               if (message.isUser) ...[
//                 SizedBox(width: 8),
//                 CircleAvatar(
//                   backgroundColor: Colors.blue[600],
//                   child: Icon(Icons.person, color: Colors.white, size: 18),
//                   radius: 16,
//                 ),
//               ],
//             ],
//           ),

//           // Options buttons (only for bot messages)
//           if (!message.isUser &&
//               message.options != null &&
//               message.options!.isNotEmpty) ...[
//             SizedBox(height: 12),
//             Padding(
//               padding: EdgeInsets.only(left: 40),
//               child: Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: message.options!.map((option) {
//                   bool isBackButton = option.startsWith('←');
//                   bool isContactButton =
//                       option.contains('Call Now') || option.contains('Contact');

//                   return ElevatedButton(
//                     onPressed: () => _handleOptionSelected(option),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isContactButton
//                           ? Colors.orange[600]
//                           : isBackButton
//                               ? Colors.grey[600]
//                               : Colors.green[600],
//                       foregroundColor: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: Text(
//                       option,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? options;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.options,
  });
}

class QuestionFlow {
  static const Map<String, Map<String, dynamic>> questionMap = {
    // Main categories
    'main': {
      'message':
          '🌿 Welcome to Ambrosia Ayurved Diabetes Support!\n\nI\'m here to help you with diabetes information. Please select what you\'d like to know about:',
      'options': [
        'What is Diabetes?',
        'Types of Diabetes',
        'Symptoms & Signs',
        'Causes & Risk Factors',
        'Diet & Nutrition',
        'Exercise & Lifestyle',
        'Management Tips',
        'Our Ayurvedic Products'
      ]
    },

    // What is diabetes
    'What is Diabetes?': {
      'message': '''**What is Diabetes? 🩺**

Diabetes is a chronic condition that occurs when your blood glucose (blood sugar) is too high. It happens when:

• Your body doesn't make enough insulin, OR
• Your body can't use insulin properly, OR
• Both

**Key Facts:**
• Insulin helps glucose enter your cells for energy
• Without proper insulin function, glucose stays in blood
• High blood glucose over time causes serious health problems
• Early detection and management are crucial

🌿 **Good News:** With proper care and natural Ayurvedic support, diabetes can be managed effectively!''',
      'options': [
        'Types of Diabetes',
        'Symptoms & Signs',
        'How is it Diagnosed?',
        'Can it be Prevented?',
        'Our Natural Solutions',
        '← Back to Main Menu'
      ]
    },

    // Types of diabetes
    'Types of Diabetes': {
      'message': '''**Types of Diabetes 📋**

**1. Type 1 Diabetes**
• Body stops making insulin
• Usually starts in childhood/young adults
• Requires insulin injections
• About 5-10% of all diabetes cases

**2. Type 2 Diabetes**
• Body doesn't use insulin well
• Most common type (90-95%)
• Often develops after age 45
• Can often be managed with lifestyle changes

**3. Gestational Diabetes**
• Develops during pregnancy
• Usually goes away after delivery
• Increases risk of Type 2 later

**4. Prediabetes**
• Blood sugar higher than normal
• Not high enough to be diabetes
• Can be reversed with lifestyle changes''',
      'options': [
        'Type 1 Details',
        'Type 2 Details',
        'Gestational Diabetes Info',
        'Prediabetes Information',
        'Which Type Do I Have?',
        '← Back to Main Menu'
      ]
    },

    // Symptoms
    'Symptoms & Signs': {
      'message': '''**Diabetes Symptoms & Warning Signs ⚠️**

**Common Early Symptoms:**
• 🚰 Frequent urination (especially at night)
• 🥤 Excessive thirst
• 😴 Unusual fatigue and weakness
• 📉 Unexplained weight loss
• 🍽️ Increased hunger
• 👁️ Blurred vision
• 🩹 Slow healing cuts/bruises
• 🦠 Frequent infections

**Advanced Symptoms:**
• Numbness in hands/feet
• Dark skin patches (acanthosis nigricans)
• Recurring skin infections
• Sweet-smelling breath

**⚠️ Emergency Signs:**
• Extreme thirst and frequent urination
• Nausea and vomiting
• Deep, rapid breathing
• Confusion or unconsciousness''',
      'options': [
        'Early vs Late Symptoms',
        'Type 1 vs Type 2 Symptoms',
        'When to See a Doctor?',
        'How to Monitor Symptoms',
        'Natural Symptom Management',
        '← Back to Main Menu'
      ]
    },

    // Causes & Risk Factors
    'Causes & Risk Factors': {
      'message': '''**Diabetes Causes & Risk Factors 🎯**

**Type 1 Causes:**
• Autoimmune reaction destroys insulin cells
• Genetic factors
• Environmental triggers (viruses, stress)
• Family history

**Type 2 Risk Factors:**
• **Age:** 45+ years
• **Weight:** Overweight/obesity
• **Family History:** Parents/siblings with diabetes
• **Lifestyle:** Sedentary lifestyle, poor diet
• **Medical:** High blood pressure, abnormal cholesterol
• **Ethnicity:** Higher risk in certain groups

**Gestational Risk Factors:**
• Age over 25
• Previous gestational diabetes
• Family history of diabetes
• Overweight before pregnancy

**🌿 Ayurvedic Perspective:**
According to Ayurveda, diabetes (Prameha) occurs due to imbalanced doshas, poor digestion, and lifestyle factors.''',
      'options': [
        'Can I Prevent Type 2?',
        'Genetic vs Lifestyle Factors',
        'Ayurvedic Understanding',
        'Risk Assessment',
        'Prevention Strategies',
        '← Back to Main Menu'
      ]
    },

    // Diet & Nutrition
    'Diet & Nutrition': {
      'message': '''**Diabetes Diet & Nutrition Guide 🥗**

**Best Foods for Diabetes:**
• **Vegetables:** Non-starchy (spinach, broccoli, peppers)
• **Proteins:** Lean meats, fish, eggs, legumes
• **Whole Grains:** Brown rice, oats, quinoa
• **Healthy Fats:** Nuts, olive oil, avocados
• **Low-GI Fruits:** Berries, apples, citrus

**Foods to Limit:**
• Refined sugars and sweets
• White bread, rice, pasta
• Sugary drinks and sodas
• Processed and fried foods
• High-sodium foods

**Ayurvedic Diet Tips:**
• Eat warm, cooked foods
• Include bitter and astringent tastes
• Avoid cold drinks with meals
• Eat largest meal at midday
• Include spices like turmeric, cinnamon''',
      'options': [
        'Meal Planning Tips',
        'Carb Counting Basics',
        'Ayurvedic Food Guidelines',
        'Snack Ideas',
        'Foods to Avoid Completely',
        '← Back to Main Menu'
      ]
    },

    // Exercise & Lifestyle
    'Exercise & Lifestyle': {
      'message': '''**Exercise & Lifestyle for Diabetes 🏃‍♂️**

**Exercise Benefits:**
• Lowers blood glucose naturally
• Increases insulin sensitivity
• Helps with weight management
• Reduces cardiovascular risk
• Improves mood and energy

**Recommended Activities:**
• **Aerobic:** 150 min/week moderate intensity
  - Brisk walking, swimming, cycling
• **Strength Training:** 2+ days/week
  - Weight lifting, resistance bands
• **Flexibility:** Yoga, stretching daily

**Lifestyle Changes:**
• Maintain regular sleep schedule (7-8 hours)
• Manage stress through meditation/yoga
• Quit smoking completely
• Limit alcohol consumption
• Stay hydrated (8-10 glasses water/day)

**🌿 Ayurvedic Lifestyle:**
• Practice pranayama (breathing exercises)
• Follow daily routine (dinacharya)
• Include morning sun exposure''',
      'options': [
        'Exercise Safety Tips',
        'Yoga for Diabetes',
        'Stress Management',
        'Sleep & Diabetes',
        'Ayurvedic Daily Routine',
        '← Back to Main Menu'
      ]
    },

    // Management Tips
    'Management Tips': {
      'message': '''**Diabetes Management Tips 📊**

**Daily Management:**
• Monitor blood sugar as recommended
• Take medications on time
• Follow consistent meal schedule
• Stay physically active
• Keep emergency supplies ready

**Long-term Care:**
• Regular doctor checkups
• Annual eye and foot exams
• Dental care every 6 months
• Blood pressure monitoring
• Cholesterol level checks

**Self-Care Essentials:**
• Learn to recognize low/high blood sugar
• Keep glucose tablets handy
• Maintain diabetes diary
• Stay informed about condition
• Build strong support system

**🌿 Ayurvedic Management:**
• Take herbs like bitter gourd, fenugreek
• Practice oil pulling (oil in mouth)
• Follow seasonal routines
• Use natural blood purifiers
• Regular panchakarma treatments''',
      'options': [
        'Blood Sugar Monitoring',
        'Medication Management',
        'Emergency Preparedness',
        'Ayurvedic Daily Practices',
        'When to Call Doctor',
        '← Back to Main Menu'
      ]
    },

    // Products
    'Our Ayurvedic Products': {
      'message': '''🌿 **Ambrosia Ayurved Diabetes Care Products**

**🍃 Sugar Shield Plus** - ₹1,299
• Natural blood glucose support
• Contains Gymnema, Bitter Gourd, Methi
• Helps reduce sugar cravings

**🍃 Diabetic Care Formula** - ₹1,599  
• Comprehensive diabetes management
• Supports pancreatic function
• Improves insulin sensitivity

**🍃 Herbal Insulin Support** - ₹1,199
• Ayurvedic insulin sensitivity booster
• Contains Vijaysar, Karela, Jamun
• Helps in glucose metabolism

**🍃 Pancreas Wellness** - ₹1,399
• Supports pancreatic health
• Natural beta cell protection
• Digestive enzyme support

**✨ Why Choose Ambrosia Ayurved?**
• 100% Natural ingredients
• Clinically tested formulations
• No harmful side effects  
• Trusted by 50,000+ customers''',
      'options': [
        'Product Details & Benefits',
        'Pricing & Offers',
        'How to Use Products',
        'Customer Reviews',
        'Order Now',
        '← Back to Main Menu'
      ]
    },

    // Follow-up questions for deeper information
    'Type 1 Details': {
      'message': '''**Type 1 Diabetes - Detailed Information 🎯**

**What Happens:**
• Immune system attacks insulin-producing beta cells
• Pancreas makes little to no insulin
• Glucose can't enter cells, stays in blood
• Usually develops quickly over weeks/months

**Who Gets It:**
• Often children, teens, young adults
• Can occur at any age
• Family history increases risk slightly
• More common in people of European descent

**Management:**
• Daily insulin injections/pump required
• Frequent blood glucose monitoring
• Carbohydrate counting essential
• Regular medical care crucial

**🌿 Ayurvedic Support:**
While insulin is essential, Ayurvedic herbs can help:
• Improve overall health and immunity
• Support digestive function
• Reduce inflammation
• Enhance quality of life''',
      'options': [
        'Insulin Types & Timing',
        'Carb Counting for Type 1',
        'Ayurvedic Support for Type 1',
        'Living with Type 1',
        'Our Supportive Products',
        '← Back to Types Menu'
      ]
    },

    'Type 2 Details': {
      'message': '''**Type 2 Diabetes - Detailed Information 📈**

**What Happens:**
• Body becomes resistant to insulin
• Pancreas can't make enough insulin
• Develops gradually over years
• Often goes undiagnosed initially

**Risk Factors:**
• Age 45+ (but increasing in younger people)
• Overweight/obesity (especially belly fat)
• Sedentary lifestyle
• Family history
• High blood pressure
• Abnormal cholesterol levels

**The Good News:**
• Can often be managed without insulin initially
• Lifestyle changes can be very effective
• May be prevented or delayed
• Natural approaches work well

**🌿 Ayurvedic Excellence:**
Type 2 responds exceptionally well to Ayurvedic treatment:
• Herbs that improve insulin sensitivity
• Natural compounds that reduce glucose absorption
• Lifestyle practices that balance metabolism''',
      'options': [
        'Lifestyle Management',
        'Medication Options',
        'Ayurvedic Treatment Approach',
        'Prevention Strategies',
        'Our Specialized Products',
        '← Back to Types Menu'
      ]
    },

    // Contact flow
    'contact': {
      'message': '''📞 **Need More Information?**

For personalized guidance and expert consultation about diabetes management and our Ayurvedic products:

**Contact Our Diabetes Care Experts:**

**📋 Our Experts Can Help With:**
• Personalized product recommendations
• Dosage and usage guidance  
• Diet and lifestyle counseling
• Product ordering and delivery
• Follow-up support

**🕒 Available:**
Monday - Saturday: 9:00 AM - 7:00 PM
Sunday: 10:00 AM - 5:00 PM

**💬 What to Expect:**
• Free 15-minute consultation
• Customized diabetes care plan
• Product recommendations based on your needs
• Ongoing support throughout your journey

🌿 **Take the first step towards natural diabetes management today!**''',
      'options': ['📞 Call Now', '💬 WhatsApp Now', '← Back to Main Menu']
    }
  };

  static List<String> getFollowUpOptions(String question) {
    return questionMap[question]?['options']?.cast<String>() ?? [];
  }

  static String getResponse(String question) {
    return questionMap[question]?['message'] ??
        'Here\'s some basic information about your query. Diabetes is a condition where blood sugar levels become too high, requiring proper management through diet, exercise, and sometimes medication.\n\nFor detailed and personalized assistance regarding your specific situation:';
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  int questionCount = 0;

  @override
  void initState() {
    super.initState();
    _startConversation();
  }

  void _startConversation() {
    messages.add(Message(
      text: QuestionFlow.getResponse('main'),
      isUser: false,
      timestamp: DateTime.now(),
      options: QuestionFlow.getFollowUpOptions('main'),
    ));
  }

  void _handleOptionSelected(String option) {
    // Add user's selection
    setState(() {
      messages.add(Message(
        text: option,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      questionCount++;
    });

    _scrollToBottom();

    // Handle special cases
    if (option == '← Back to Main Menu') {
      _addBotResponse('main');
      return;
    }

    if (option == '← Back to Types Menu') {
      _addBotResponse('Types of Diabetes');
      return;
    }

    // Handle contact options
    if (option == '📞 Call Now') {
      _makePhoneCall();
      return;
    }

    if (option == '💬 WhatsApp Now') {
      _openWhatsApp();
      return;
    }

    // Add bot response after delay
    Future.delayed(Duration(milliseconds: 800), () {
      _addBotResponse(option);
    });
  }

  void _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+918000057233');
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Call +91-8000057233 for assistance'),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please call +91-8000057233 for assistance'),
          backgroundColor: Colors.green[700],
        ),
      );
    }
  }

  void _openWhatsApp() async {
    final String whatsappMessage = Uri.encodeComponent(
        'Hi Ambrosia Ayurved! I need information about diabetes management and your Ayurvedic products.');
    final Uri whatsappUri =
        Uri.parse('https://wa.me/918000057233?text=$whatsappMessage');

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WhatsApp us at +91-8000057233'),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please WhatsApp us at +91-8000057233'),
          backgroundColor: Colors.green[700],
        ),
      );
    }
  }

  void _addBotResponse(String questionKey) {
    String response = QuestionFlow.getResponse(questionKey);
    List<String> options = QuestionFlow.getFollowUpOptions(questionKey);

    // After answering 3-4 questions, show contact message
    if (questionCount >= 3 &&
        questionKey != 'main' &&
        questionKey != 'contact' &&
        !questionKey.contains('←')) {
      response +=
          '\n\n📞 **Need personalized guidance?** Contact our diabetes care experts for customized advice and product recommendations!';
    }

    // If no specific options, provide contact option
    if (options.isEmpty && questionKey != 'main') {
      options = ['📞 Call Now', '💬 WhatsApp Now', '← Back to Main Menu'];
    }

    // Handle contact option
    if (questionKey == 'Contact Our Experts' ||
        questionKey == '📞 Call Now' ||
        questionKey == '💬 WhatsApp Now') {
      response = QuestionFlow.getResponse('contact');
      options = QuestionFlow.getFollowUpOptions('contact');
    }

    setState(() {
      messages.add(Message(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
        options: options,
      ));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Ambrosia Diabetes Care",
        leading: BackButton(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.2),
              ),
              child: IconButton(
                icon: Icon(Icons.phone, color: Colors.black),
                onPressed: () => _makePhoneCall(),
                tooltip: 'Call Us',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.2),
              ),
              child: IconButton(
                icon: Icon(Icons.chat, color: Colors.black),
                onPressed: () => _openWhatsApp(),
                tooltip: 'WhatsApp Us',
              ),
            ),
          ),
        ],
      ),
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Icon(Icons.local_hospital, color: Colors.white),
      //       SizedBox(width: 8),
      //       Expanded(
      //         child: Text(
      //           'Ambrosia Diabetes Care',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 18,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: Colors.green[700],
      //   elevation: 2,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(messages[index]);
                },
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border(
                  top: BorderSide(color: Colors.green[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.green[700], size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Call: +91-8000057233',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.chat, color: Colors.green[700], size: 16),
                  SizedBox(width: 4),
                  Text(
                    'WhatsApp',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message bubble
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                CircleAvatar(
                  backgroundColor: Colors.green[700],
                  child:
                      Icon(Icons.local_hospital, color: Colors.white, size: 18),
                  radius: 16,
                ),
                SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                        message.isUser ? Colors.green[700] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (message.isUser) ...[
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue[600],
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                  radius: 16,
                ),
              ],
            ],
          ),

          // Options buttons (only for bot messages)
          if (!message.isUser &&
              message.options != null &&
              message.options!.isNotEmpty) ...[
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(left: 40),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.options!.map((option) {
                  bool isBackButton = option.startsWith('←');
                  bool isContactButton =
                      option.contains('Call Now') || option.contains('Contact');

                  return ElevatedButton(
                    onPressed: () => _handleOptionSelected(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isContactButton
                          ? Colors.orange[600]
                          : isBackButton
                              ? Colors.grey[600]
                              : Acolors.primary,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
