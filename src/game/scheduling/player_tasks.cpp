#include "pch.hpp"
#include "game/game.h"
#include "game/scheduling/player_tasks.h"

PlayerTask* playerCreateTask(std::function<void(void)> f) {
    return new PlayerTask(std::move(f));
}

PlayerTask* playerCreateTask(uint32_t expiration, std::function<void(void)> f) {
    return new PlayerTask(expiration, std::move(f));
}

void PlayerDispatcher::threadMain(int index) {
    std::unique_lock<std::mutex> taskLockUnique(taskLock[index], std::defer_lock);
    std::condition_variable& taskSignalThread = taskSignal[index];
    std::list<PlayerTask*>& taskListThread = taskList[index];

    while (getState() != THREAD_STATE_TERMINATED) {
        taskLockUnique.lock();

        if (taskListThread.empty()) {
            taskSignalThread.wait(taskLockUnique, [this, &taskListThread] {
                return !taskListThread.empty() || getState() == THREAD_STATE_TERMINATED;
            });
        }

        if (!taskListThread.empty()) {
			// take the first task
            PlayerTask* task = taskListThread.front();
            taskListThread.pop_front();

            if (!task->hasExpired()) {
                ++dispatcherCycle;
                (*task)();
            }

            delete task;
        }

		taskLockUnique.unlock();
    }
}

void PlayerDispatcher::playerAddTask(PlayerTask* task, int index, bool push_front /*= false*/) {
    bool do_signal = false;

    taskLock[index].lock();

    if (getState() == THREAD_STATE_RUNNING) {
        do_signal = taskList[index].empty();

        if (push_front) {
            taskList[index].push_front(task);
        } else {
            taskList[index].push_back(task);
        }
    } else {
        delete task;
    }

    taskLock[index].unlock();

    if (do_signal) {
        taskSignal[index].notify_one();
    }
}

void PlayerDispatcher::shutdown() {
    for (int index = 0; index < threads.size(); ++index) {
        PlayerTask* task = playerCreateTask([this, index]() {
            setState(THREAD_STATE_TERMINATED);
            taskSignal[index].notify_one();
        });

        std::lock_guard<std::mutex> lockClass(taskLock[index]);
        taskList[index].push_back(task);

        taskSignal[index].notify_one();
    }
}