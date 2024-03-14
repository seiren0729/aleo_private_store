// The 'store_seiren' program.
program store_seiren.aleo {
    mapping items: u8 => u64;
    mapping prices: u8 => u64;

    record Token {
        owner: address,
        amount: u64
    }

    record Item {
        owner: address,
        item: u8,
        quantity: u64
    }

    transition mint(receiver: address, amount: u64) -> Token {
        assert_eq(self.caller, aleo1jnc0zu0jmttwlullcjcneww5ck37znj3ut97rye47g87cn9k7vqsvvcqq4);

        return Token {
            owner: receiver,
            amount: amount
        };
    }

    transition add_item(item: u8, quantity: u64, price: u64) {
        assert_eq(self.caller, aleo1jnc0zu0jmttwlullcjcneww5ck37znj3ut97rye47g87cn9k7vqsvvcqq4);

        return then finalize(item, quantity, price);
    }

    finalize add_item (item: u8, quantity: u64, price: u64) {
        let item_count: u64 = Mapping::get_or_use(items, item, 0u64);
        Mapping::set(items, item, item_count + quantity);

        Mapping::set(prices, item, price);
    }
    
    transition buy(token: Token, item: u8, quantity: u64, bill_amount: u64) -> (Token, Item) {
        let difference: u64 = token.amount - bill_amount;
        
        let remaining: Token = Token {
            owner: token.owner,
            amount: difference
        };

        let item_record: Item = Item {
            owner: self.caller,
            item: item,
            quantity: quantity
        };

        return (remaining, item_record) then finalize(item, quantity, bill_amount);
    }

    finalize buy (item: u8, quantity: u64, bill_amount: u64) {
        let available_quantity: u64 = Mapping::get_or_use(items, item, 0u64);
        assert(available_quantity >= quantity);
        // Mapping::set(items, item, available_quantity - quantity);

        let item_price: u64 = Mapping::get_or_use(prices, item, 0u64);
        assert_neq(item_price, 0u64);

        let total_price: u64 = item_price * quantity;
        assert_eq(total_price, bill_amount);
    }

    transition transfer_item(item: Item, receiver: address) -> Item {
        let transfered_item: Item = Item {
            owner: receiver,
            item: item.item,
            quantity: item.quantity
        };

        return transfered_item;
    }
}
