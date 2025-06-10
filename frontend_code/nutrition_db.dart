import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addNutritionPlans() async {
    List<Map<String, dynamic>> dietPlans = [
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Clear",
        "diet_plan":
            "Hydrate with plenty of water\nConsume Omega-3 rich foods like salmon or walnuts\nIncrease Vitamin E intake through almonds, sunflower seeds, and green leafy vegetables", // 1
      },
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Acne",
        "diet_plan":
            "Increase water intake\nAdd Vitamin A and Zinc-rich foods (carrots, spinach, and pumpkin seeds)\nReduce sugar intake\nIncorporate fiber-rich foods like oats and flaxseeds", // 2
      },
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Comedo",
        "diet_plan":
            "Stay hydrated with coconut water\nEat Vitamin C-rich foods (oranges, strawberries)\nAvoid dairy\nInclude probiotics (yogurt, kefir) to maintain healthy skin", // 3
      },
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Clear",
        "diet_plan":
            "Hydrate with water-rich foods like cucumbers\nIncrease Vitamin C intake (citrus fruits, bell peppers)\nAdd healthy fats from avocado to moisturize skin", // 4
      },
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Acne",
        "diet_plan":
            "Stay hydrated with smoothies\nAdd antioxidant-rich foods (berries, spinach, kale)\nAvoid greasy or fried foods to prevent acne breakouts", // 5
      },
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Comedo",
        "diet_plan":
            "Drink green tea for its anti-inflammatory properties\nEat foods high in Vitamin A (sweet potatoes, carrots)\nLimit dairy for healthier skin", // 6
      },
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Clear",
        "diet_plan":
            "Hydrate with papaya and watermelon\nInclude Omega-3-rich foods (flaxseeds, chia seeds) for skin repair\nIncrease Vitamin E intake through almonds, sunflower seeds, and spinach", // 7
      },
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Acne",
        "diet_plan":
            "Drink water to prevent dryness\nEat Vitamin C-rich foods (e.g., kiwi, citrus fruits) to support skin regeneration\nAvoid sugar and processed food to prevent acne flare-ups\nConsume antioxidant-rich foods like dark chocolate", // 8
      },
      {
        "nutrition_skin_type": "dry",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Comedo",
        "diet_plan":
            "Stay hydrated\nEat Zinc-rich foods (e.g., chickpeas, almonds) to prevent clogged pores\nAvoid high-sugar and greasy foods", // 9
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Clear",
        "diet_plan":
            "Consume antioxidant-rich foods (berries, tomatoes)\nStay hydrated with water and green tea\nInclude Omega-3-rich foods to balance oil production", // 10
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Acne",
        "diet_plan":
            "Increase water intake to flush out toxins\nAdd foods with high Vitamin A (carrots, spinach) to control sebum production\nLimit dairy and refined sugars\nInclude antioxidant-rich foods like dark chocolate and berries", // 11
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Comedo",
        "diet_plan":
            "Stay hydrated with water, coconut water, and green tea\nIncrease Vitamin A and Zinc intake (e.g., pumpkin seeds, leafy greens)\nAvoid high-fat and greasy foods to reduce pore blockages", // 12
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Clear",
        "diet_plan":
            "Focus on hydrating foods like cucumbers\nEat foods rich in Vitamin C (e.g., citrus fruits, tomatoes)\nConsume Omega-3 fatty acids (e.g., salmon, chia seeds) to balance oil production", // 13
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Acne",
        "diet_plan":
            "Stay hydrated with water and herbal teas\nInclude foods rich in Vitamin C (e.g., kiwi, citrus fruits)\nAvoid fried and greasy foods that can increase sebum production", // 14
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Comedo",
        "diet_plan":
            "Drink water and green tea to manage oil levels\nInclude foods rich in antioxidants (e.g., berries, leafy greens) to reduce inflammation\nAvoid processed foods and dairy products to reduce clogged pores", // 15
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Clear",
        "diet_plan":
            "Stay hydrated with water and hydrating foods like cucumbers\nFocus on foods rich in Vitamin E (e.g., almonds, avocados)\nInclude healthy fats (e.g., salmon, chia seeds) to keep skin nourished", // 16
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Acne",
        "diet_plan":
            "Increase water intake\nFocus on Vitamin A-rich foods (e.g., sweet potatoes, spinach)\nLimit sugar and processed foods\nInclude fiber-rich foods (e.g., lentils, oats) for better skin health", // 17
      },
      {
        "nutrition_skin_type": "oily",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Comedo",
        "diet_plan":
            "Stay hydrated with water, coconut water, and green tea\nConsume Omega-3-rich foods (e.g., salmon, chia seeds)\nAvoid greasy foods to prevent clogged pores", // 18
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Clear",
        "diet_plan":
            "Drink plenty of water\nInclude antioxidant-rich foods (e.g., berries, tomatoes)\nConsume Vitamin E-rich foods (e.g., nuts, seeds) for healthy skin", // 19
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Acne",
        "diet_plan":
            "Increase water intake\nAdd Vitamin A-rich foods (carrots, spinach)\nAvoid excessive dairy\nConsume Omega-3 fatty acids (e.g., flaxseeds, salmon) to reduce inflammation", // 20
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Fair_light",
        "acne_severity": "Comedo",
        "diet_plan":
            "Stay hydrated with water and green tea\nEat foods rich in Vitamin C (e.g., kiwi, citrus fruits)\nLimit sugar intake to reduce comedo formation", // 21
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Clear",
        "diet_plan":
            "Focus on hydrating foods like watermelon and cucumbers\nIncrease Vitamin C intake (e.g., oranges, strawberries)\nInclude healthy fats from avocados for moisturized skin", // 22
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Acne",
        "diet_plan":
            "Drink plenty of water\nEat foods rich in antioxidants (e.g., spinach, kale)\nAvoid sugar and processed foods to prevent acne", // 23
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Medium_tane",
        "acne_severity": "Comedo",
        "diet_plan":
            "Stay hydrated with water and herbal teas\nInclude Vitamin A and Zinc-rich foods (sweet potatoes, nuts)\nAvoid greasy foods to prevent clogged pores", // 24
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Clear",
        "diet_plan":
            "Drink water and eat hydrating fruits like papaya and watermelon\nInclude Omega-3-rich foods (salmon, walnuts) for skin repair\nAdd Vitamin E-rich foods (spinach, almonds) to promote healthy skin", // 25
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Acne",
        "diet_plan":
            "Stay hydrated with water and herbal teas\nEat foods rich in Vitamin C (kiwi, bell peppers) to heal skin\nAvoid processed sugars to prevent acne flare-ups", // 26
      },
      {
        "nutrition_skin_type": "normal",
        "nutrition_skin_tone": "Dark_deep",
        "acne_severity": "Comedo",
        "diet_plan":
            "Drink plenty of water\nFocus on Vitamin A-rich foods (carrots, sweet potatoes) to clear pores\nLimit dairy and processed foods to prevent comedo formation", // 27
      },
    ];

    for (var plan in dietPlans) {
      await _db.collection('nutrition').add(plan).catchError((e) {
        print("Error adding document: $e");
      });
    }
    print("Nutrition plans added successfully.");
  }
}
