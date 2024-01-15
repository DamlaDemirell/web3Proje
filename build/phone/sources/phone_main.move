module phone::phone_main{
    use sui::transfer;
    use sui::object::{Self,UID,ID};
    use sui::url::{Self,Url};
    use sui::tx_context::{Self,TxContext};
    use std::string::{Self,String};

    const NOT_THE_PHONE_OWNER: u64 = 0;


    struct Phone has key,store {
        id:UID,
        name:String,
        weight: u64,
        owner:address,
        model:String,
        color:String,
        price:u64,
   }

    struct AdminCap has key {
        id:UID,
        active:bool  
    }


    fun init (ctx:&mut TxContext) {
      transfer::transfer(AdminCap{ id: object::new(ctx), active:false}, tx_context::sender(ctx) );

   }

  // &mut ? //
  public entry fun create_Phone (
    name: vector<u8>, 
    _weight:u64,
    model:vector<u8>,
    color:vector<u8>,
    _price:u64,
    ctx:&mut TxContext) 
    {
      
    let phone = Phone {
        id:object::new(ctx),
        name:string::utf8(name),
        weight:_weight,
        owner:tx_context::sender(ctx),
        model:string::utf8(model),
        color:string::utf8(color),
        price:_price,

        // tx_context: that means transaction 
    };
    let sender = tx_context::sender(ctx);
    transfer::public_transfer(phone,tx_context::sender(ctx))
}

public entry fun update_phone(phone:&mut Phone, _price:u64, ctx:&mut TxContext) {
    assert!(phone.owner == tx_context::sender(ctx), 0);
    phone.price = _price;
} 

public fun get_info(phone:&Phone) : (String, u64,address, String, String, u64)   { 
  (
    phone.name,
    phone.weight,
    phone.owner,
    phone.model,
    phone.color,
    phone.price
  )
  
 }

 #[test_only]
  public fun init_for_testing(ctx: &mut TxContext) {
    init(ctx); 
}

public fun return_phone(phone:&Phone) : u64  {
    phone.price
}


}

