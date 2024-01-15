#[test_only]
module phone::phone_test {

    use sui::test_scenario;
    use sui::coin::{Self,Coin,mint_for_testing};
    use sui::sui::SUI;
    use sui::object_table;
    use phone::phone_main;
    use sui::test_utils::{assert_eq};
    use phone::phone_main::Phone;


     #[test]

     fun create_phone() {

         let owner: address = @0xA;
         let user1: address = @0xB;
         let user2: address = @0xC;

    // 0x5fb75c1761c43acfd30b99443d4307101f57391cb1a4b7eb5d795fd91a8aa87a

      let scenario_val = test_scenario::begin(owner);
      let scenario = &mut scenario_val;

      test_scenario::next_tx(scenario, owner);
      {
        phone_main::init_for_testing(test_scenario::ctx(scenario));

      };

      test_scenario:: next_tx(scenario, user1);
      {
        let name = b"MyPhone";
        let weight:u64 = 100;
        let model = b"12";
        let color = b"purple";
        let price:u64 = 50000;

        phone_main::create_Phone(name, weight, model, color, price, test_scenario::ctx(scenario));

      };

      test_scenario::next_tx(scenario, user1);
      {
        let new_price:u64 = 61000;
        let phone = test_scenario::take_from_sender<phone_main::Phone>(scenario);

        phone_main::update_phone(&mut phone, new_price, test_scenario::ctx(scenario));

       // assert_eq(phone.price , 61000);

        test_scenario::return_to_sender(scenario, phone);

      };

        test_scenario::next_tx(scenario, user1);
      {
        let new_price:u64 = 61000;
        let phone = test_scenario::take_from_sender<phone_main::Phone>(scenario);
        let phone2 = phone_main::return_phone(&phone);

        assert_eq(phone2 , 61000);

        test_scenario::return_to_sender<phone_main::Phone>(scenario, phone);

      };



        test_scenario::end(scenario_val);
     }








}