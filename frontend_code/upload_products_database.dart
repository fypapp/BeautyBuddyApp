import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_service.dart';

List<Map<String, dynamic>> products = [
  {
    "name": "CeraVe Moisturizer",
    "type": "Moisturizer",
    "skin_type": "dry",
    "skin_tone": "Fair_light",
    "acne_compatible": "Clear",
    "image_url": "assets/images/CeraVe Daily Moisturizing Lotion.png",
    "description":
        "Moisturizes and restores the skin’s natural protective barrier.", // 1
  },
  {
    "name": "Neutrogena Acne Gel",
    "type": "Gel",
    "skin_type": "dry",
    "skin_tone": "Fair_light",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Neutrogena Acne Gel.png",
    "description": "Treats acne, reduces blemishes with salicylic acid.", // 2
  },
  {
    "name": "La Roche-Posay Cleanser",
    "type": "Cleanser",
    "skin_type": "dry",
    "skin_tone": "Fair_light",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/La Roche-Posay Cleanser.png",
    "description": "Gently cleanses and reduces blackheads.", // 3
  },
  {
    "name": "Nivea Soft Moisturizer",
    "type": "Moisturizer",
    "skin_type": "dry",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Nivea_Soft_Moisturizer.png",
    "description":
        "Lightweight moisturizer for dry skin, restores hydration.", // 4
  },
  {
    "name": "Vanicream Facial Cleanser",
    "type": "Cleanser",
    "skin_type": "dry",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Vanicream Facial Cleanser.png",
    "description":
        "Non-foaming, gentle cleanser that removes dirt and oil.", // 5
  },
  {
    "name": "CeraVe Hydrating Cleanser",
    "type": "Cleanser",
    "skin_type": "dry",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Comedo",
    "image_url":
        "assets/images/CeraVe Hydrating Cleanser for Normal to Dry Skin 473ml with Hyaluronic Acid & 3 Essential Ceramides.png",
    "description": "Removes dirt while restoring skin moisture balance.", // 6
  },
  {
    "name": "Eucerin Advanced Repair Cream",
    "type": "Cream",
    "skin_type": "dry",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Eucerin Advanced Repair Cream.png",
    "description":
        "Provides long-lasting hydration and repairs very dry skin.", // 7
  },
  {
    "name": "The Ordinary Hyaluronic Acid 2% + B5",
    "type": "Gel",
    "skin_type": "dry",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Acne",
    "image_url": "assets/images/The Ordinary Niacinamide 10% + Zinc 1%.png",
    "description":
        "Cleanses and purifies acne-prone skin without stripping.", // 8
  },
  {
    "name": "Cleansing Oil by DHC",
    "type": "Oil",
    "skin_type": "dry",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/DHC Derp Cleansing Oil.png",
    "description": "Gently removes makeup and deeply cleanses pores.", // 9
  },
  {
    "name": "La Roche-Posay Effaclar Purifying Foaming Gel",
    "type": "Cleanser",
    "skin_type": "oily",
    "skin_tone": "Fair_light",
    "acne_compatible": "Clear",
    "image_url":
        "assets/images/La Roche-Posay Effaclar Purifying Foaming Gel.png",
    "description":
        "Removes impurities and excess oil, leaving skin refreshed.", // 10
  },
  {
    "name": "Clean & Clear Advantage Acne Spot Treatment",
    "type": "Gel",
    "skin_type": "oily",
    "skin_tone": "Fair_light",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Clean&Clear.png",
    "description":
        "Fast-acting acne treatment that reduces pimples and helps prevent future breakouts.", // 11
  },
  {
    "name": "Clean & Clear Advantage Acne Control Kit",
    "type": "Kit",
    "skin_type": "oily",
    "skin_tone": "Fair_light",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Clean&ClearAcneKit.png",
    "description": "Provides an acne-fighting regimen to minimize pores.", // 12
  },
  {
    "name": "Clinique Acne Solutions Oil-Control Gel",
    "type": "Gel",
    "skin_type": "oily",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Clinique Acne Solutions Oil-Control Gel.png",
    "description":
        "Oil-free gel that helps control shine and prevent acne.", // 13
  },
  {
    "name": "Aveda Botanical Kinetics Purifying Gel Cleanser",
    "type": "Cleanser",
    "skin_type": "oily",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Acne",
    "image_url":
        "assets/images/Aveda Botanical Kinetics Purifying Gel Cleanser.png",
    "description":
        "Deep cleanses to remove excess oils and prevent acne.", // 14
  },
  {
    "name": "Mario Badescu Glycolic Foaming Cleanser",
    "type": "Cleanser",
    "skin_type": "oily",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Mario Badescu Glycolic Foaming Cleanser.png",
    "description": "Exfoliates and deep cleans to reduce blackheads.", // 15
  },
  {
    "name": "Biore Charcoal Cleanser",
    "type": "Cleanser",
    "skin_type": "oily",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Biore Charcoal Cleanser.png",
    "description": "Charcoal absorbs excess oil and purifies the skin.", // 16
  },
  {
    "name": "Murad Acne Control Clarifying Cleanser",
    "type": "Cleanser",
    "skin_type": "oily",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Murad Acne Control Clarifying Cleanser.png",
    "description": "Gently treats acne while controlling oil production.", // 17
  },
  {
    "name": "Bioré Baking Soda Acne Scrub",
    "type": "Scrub",
    "skin_type": "oily",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Bioré Baking Soda Acne Scrub.png",
    "description": "Exfoliates deeply to clear blackheads and blemishes.", // 18
  },
  {
    "name": "Cetaphil Daily Facial Cleanser",
    "type": "Cleanser",
    "skin_type": "normal",
    "skin_tone": "Fair_light",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Cetaphil Daily Facial Cleanser.png",
    "description": "Cleanses without stripping skin’s natural moisture.", // 19
  },
  {
    "name": "PCA Skin Blemish Control Gel",
    "type": "Gel",
    "skin_type": "normal",
    "skin_tone": "Fair_light",
    "acne_compatible": "Acne",
    "image_url": "assets/images/PCA Skin Acne Gel Advanced Treatment.png",
    "description": "Targets acne while maintaining the skin’s balance.", // 20
  },
  {
    "name": "Paula's Choice Clear Acne Spot Treatment",
    "type": "Treatment",
    "skin_type": "normal",
    "skin_tone": "Fair_light",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Paulas Choice Clear Acne Spot Treatment.png",
    "description":
        "Combats acne with effective ingredients like salicylic acid.", // 21
  },
  {
    "name": "Olay Regenerist Whip Moisturizer",
    "type": "Moisturizer",
    "skin_type": "normal",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Olay Regenerist Whip Moisturizer.png",
    "description":
        "Lightweight yet deeply hydrates without clogging pores.", // 22
  },
  {
    "name": "Boscia Detoxifying Black Cleanser",
    "type": "Cleanser",
    "skin_type": "normal",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Boscia Detoxifying Black Cleanser.png",
    "description": "Removes toxins and hydrates while treating acne.", // 23
  },
  {
    "name": "Mario Badescu Whitening Mask",
    "type": "Mask",
    "skin_type": "normal",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Mario Badescu Whitening Mask.png",
    "description": "Reduces dark spots and clears blackheads.", // 24
  },
  {
    "name": "Eminence Clear Skin Probiotic Moisturizer",
    "type": "Moisturizer",
    "skin_type": "normal",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Eminence Clear Skin Probiotic Moisturizer.png",
    "description":
        "Calms skin and reduces excess oil while preventing acne.", // 25
  },
  {
    "name": "Cleansing Milk by Dermalogica",
    "type": "Cleanser",
    "skin_type": "normal",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Cleansing Milk by Dermalogica.png",
    "description": "Gently cleanses and controls acne-prone skin.", // 26
  },
  {
    "name": "Clarins Gentle Foaming Cleanser",
    "type": "Cleanser",
    "skin_type": "normal",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Clarins Gentle Foaming Cleanser.png",
    "description": "Removes impurities without drying out the skin.", // 27
  },
  {
    "name": "EltaMD UV Clear Broad-Spectrum SPF 46",
    "type": "Sunscreen",
    "skin_type": "dry",
    "skin_tone": "Fair_light",
    "acne_compatible": "Clear",
    "image_url": "assets/images/EltaMD UV Clear Broad Spectrum SPF 46.png",
    "description":
        "Protects sensitive skin from UVA and UVB rays while soothing and calming.", // 28
  },
  {
    "name": "Differin Gel",
    "type": "Treatment",
    "skin_type": "dry",
    "skin_tone": "Fair_light",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Differin Gel.png",
    "description":
        "Targets acne while preventing future breakouts with retinoid action.", // 29
  },
  {
    "name": "CeraVe Hydrating Facial Cleanser",
    "type": "Cleanser",
    "skin_type": "dry",
    "skin_tone": "Fair_light",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/CeraVe Hydrating Facial Cleanse.png",
    "description":
        "Hydrates and gently cleanses while removing impurities.", // 30
  },
  {
    "name": "Neutrogena Hydro Boost Water Gel",
    "type": "Moisturizer",
    "skin_type": "dry",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Neutrogena Hydro Boost Water Gel.png",
    "description":
        "Provides intense hydration with a light, refreshing formula.", // 31
  },
  {
    "name": "Smashbox Photo Finish Foundation Primer",
    "type": "Primer",
    "skin_type": "dry",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Smashbox Photo Finish Foundation Primer.png",
    "description":
        "Minimizes pores, smooths the skin, and creates a flawless base for foundation.", // 32
  },
  {
    "name": "Pixi Glow Tonic",
    "type": "Toner",
    "skin_type": "dry",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Pixi Glow Tonic.png",
    "description":
        "Gently exfoliates and helps remove dead skin cells, reducing blackheads.", // 33
  },
  {
    "name": "The Ordinary Hyaluronic Acid 2% + B5",
    "type": "Serum",
    "skin_type": "dry",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Clear",
    "image_url": "assets/images/The Ordinary Niacinamide 10% + Zinc 1%.png",
    "description": "Hydrates and plumps the skin with deep moisture.", // 34
  },
  {
    "name": "Fenty Beauty Pro Filt’r Soft Matte Longwear Foundation",
    "type": "Foundation",
    "skin_type": "dry",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Acne",
    "image_url":
        "assets/images/Fenty Beauty Pro Filtr Soft Matte Longwear Foundation.png",
    "description":
        "Provides full coverage and controls oil without drying out the skin.", // 35
  },
  {
    "name": "Sunday Riley Juno Essential Face Oil",
    "type": "Face Oil",
    "skin_type": "dry",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Sunday Riley Juno Essential Face Oil.png",
    "description":
        "Nourishes and revitalizes with essential fatty acids.", // 36
  },
  {
    "name": "Thayers Witch Hazel Toner",
    "type": "Toner",
    "skin_type": "oily",
    "skin_tone": "Fair_light",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Thayers Witch Hazel Toner.png",
    "description": "Refines pores and removes excess oil.", // 37
  },
  {
    "name": "Cetaphil Daily Facial Cleanser",
    "type": "Cleanser",
    "skin_type": "oily",
    "skin_tone": "Fair_light",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Cetaphil Daily Facial Cleanser.png",
    "description": "Gently removes dirt, excess oils, and makeup.", // 38
  },
  {
    "name": "Clean & Clear Advantage Acne Spot Treatment",
    "type": "Treatment",
    "skin_type": "oily",
    "skin_tone": "Fair_light",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Clean&Clear.png",
    "description": "Targets pimples with a fast-acting formula.", // 39
  },
  {
    "name": "Clinique Dramatically Different Moisturizing Gel",
    "type": "Moisturizer",
    "skin_type": "oily",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Clear",
    "image_url":
        "assets/images/Clinique Dramatically Different Moisturizing Gel.png",
    "description":
        "Oil-free moisturizer to hydrate while controlling shine.", // 40
  },
  {
    "name": "Estée Lauder Double Wear Stay-in-Place Foundation",
    "type": "Foundation",
    "skin_type": "oily",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Acne",
    "image_url":
        "assets/images/Estée Lauder Double Wear Stay-in-Place Foundation.png",
    "description":
        "Long-wear foundation that controls oil and covers blemishes.", // 41
  },
  {
    "name": "Benefit Cosmetics The POREfessional Primer",
    "type": "Primer",
    "skin_type": "oily",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Benefit Cosmetics The POREFessional Primer.png",
    "description":
        "Minimizes the appearance of pores and mattifies oily skin.", // 42
  },
  {
    "name": "Neutrogena Clear Face Sunscreen SPF 55",
    "type": "Sunscreen",
    "skin_type": "oily",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Neutrogena Clear Face Sunscreen SPF 55.png",
    "description":
        "Protects against UVA/UVB rays without clogging pores.", // 43
  },
  {
    "name": "The Ordinary Niacinamide 10% + Zinc 1%",
    "type": "Serum",
    "skin_type": "oily",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Acne",
    "image_url": "assets/images/The Ordinary Niacinamide 10% + Zinc 1%.png",
    "description":
        "Reduces blemishes, controls oil production, and minimizes pores.", // 44
  },
  {
    "name": "Aztec Secret Indian Healing Clay Mask",
    "type": "Face Mask",
    "skin_type": "oily",
    "skin_tone": "Dark_deep",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Aztec Secret Indian Healing Clay Mask.png",
    "description": "Deep pore cleansing and detoxifying clay mask.", // 45
  },
  {
    "name": "Supergoop! Unseen Sunscreen SPF 40",
    "type": "Sunscreen",
    "skin_type": "normal",
    "skin_tone": "Fair_light",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Supergoop! Unseen Sunscreen SPF 40.png",
    "description":
        "Weightless sunscreen that provides a natural, matte finish.", // 46
  },
  {
    "name": "Paula’s Choice Clear Acne Spot Treatment",
    "type": "Treatment",
    "skin_type": "normal",
    "skin_tone": "Fair_light",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Paulas Choice Clear Acne Spot Treatment.png",
    "description":
        "Fast-acting acne spot treatment with benzoyl peroxide.", // 47
  },
  {
    "name": "Fresh Soy Face Cleanser",
    "type": "Cleanser",
    "skin_type": "normal",
    "skin_tone": "Fair_light",
    "acne_compatible": "Comedo",
    "image_url": "assets/images/Fresh Soy Face Cleanser.png",
    "description":
        "Gently cleanses the skin while maintaining moisture balance.", // 48
  },
  {
    "name": "Olay Regenerist Whip",
    "type": "Moisturizer",
    "skin_type": "normal",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Clear",
    "image_url": "assets/images/Olay Regenerist Whip.png",
    "description":
        "Ultra-light moisturizer that visibly firms and brightens the skin.", // 49
  },
  {
    "name": "Paula’s Choice Skin Recovery Toner",
    "type": "Toner",
    "skin_type": "normal",
    "skin_tone": "Medium_tane",
    "acne_compatible": "Acne",
    "image_url": "assets/images/Paulas Choice Skin Recovery Toner.png",
    "description":
        "Hydrating toner that replenishes the skin and soothes redness.", // 50
  },
];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseService firebaseService = FirebaseService();

  await firebaseService.uploadProducts(products);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeautyBuddy App',
      home: Scaffold(
        appBar: AppBar(title: Text('Product Upload')),
        body: Center(child: Text("Uploading products...")),
      ),
    );
  }
}
