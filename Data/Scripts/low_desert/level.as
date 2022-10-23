#include "timed_execution/timed_execution.as"
#include "timed_execution/after_init_job.as"
#include "timed_execution/delayed_job.as"

TimedExecution timer;

void Init(string level_name){
}

void Update(int is_paused){
    timer.Update();
}

bool HasFocus(){
    return false;
}

void ReceiveMessage(string msg){
    TokenIterator token_iter;
    token_iter.Init();

    if(!token_iter.FindNextToken(msg)){
        return;
    }
    
    string token = token_iter.GetToken(msg);

    if(token == "post_reset" || token == "drika_checkpoint_loaded"){
        timer.Add(AfterInitJob(function(){
            ResetAllVelocity();
        }));

        timer.Add(DelayedJob(0.1f, function(){
            ResetAllVelocity();
        }));
    }
}

void ResetAllVelocity(){
    int num = GetNumCharacters();
    for(int i = 0; i < num; ++i){
        MovementObject@ char = ReadCharacter(i);
        char.velocity = vec3(0.0f);
    }
}