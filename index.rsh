'reach 0.1';

const COUNTDOWN = 20;

const Shared = {
  showTime: Fun([UInt], Null)
}

export const main = Reach.App(() => {
  const A = Participant('Alice', {
    ...Shared,
    // Specify Alice's interact interface here
    inherit: UInt,
    getChoice: Fun([], Bool)
  });
  const B = Participant('Bob', {
    ...Shared,
    // Specify Bob's interact interface here
    acceptTerms: Fun([UInt], Bool)
  });
  init();

  A.only(() =>{
    const amt = declassify(interact.inherit)
  })
  // Alice deploys the contract and pays the contract the inherit
  A.publish(amt).pay(amt);
  commit();
  
  // The second one to publish always attaches
  B.only(() => {
   const terms = declassify(interact.acceptTerms(amt)) 
  })
  B.publish(terms);
  commit();

  each([A, B], () => {
    interact.showTime(COUNTDOWN)
  })

  A.only(() => {
    const option = declassify(interact.getChoice())
  })
  A.publish(option)
  if(option){
    transfer(amt).to(A)
  }else{
    transfer(amt).to(B)
  }
  commit()

  // write your program here
  exit();
});